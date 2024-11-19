# Gestió de fallades

En aquest apartat, assumirem que el disc dur secundari `/dev/nvme0n3` ha fallat. Aquest disc forma part del grup de volums `vg_webapp` i conté el volum lògic `lv_data` que emmagatzema les dades estàtiques de la web. La fallada del disc dur pot ser deguda a diversos factors, com ara errors de hardware, errors de software, o errors de configuració.

## Preparació

- Utilitzeu la màquina virtual creada a l'apartat anterior amb el grup de volums `vg_webapp` i el volum lògic `lv_data`.

- Escriviu dades aleatòries a l’arxiu `/opt/webapp/data` per simular les dades del lloc web. Podeu utilitzar l’script següent:

    ```bash
    #!/bin/bash

    # Numero de gigabytes a escriure
    amountGB="$1"

    # Directori on escriure els arxius (per defecte /opt/webapp/data)
    dir="${2:-/opt/webapp/data}"

    for i in $(seq 1 "$amountGB"); do
        dd if=/dev/urandom of="$dir/file$i" bs=1M count=1024
    done

    echo "S'han escrit $amountGB GB de dades a $dir"
    ```

    Executeu el script amb la següent comanda per escriure 5GB de dades a l'arxiu `/opt/webapp/data`:

    ```bash
    bash script.sh 5
    ```

## Tasques

### Anàlisi de la fallada

En primer lloc, analitzarem amb més detall utiltizant `pvdisplay --maps` i `lvdisplay --maps` per entendre com estan distribuïts els extens del grup de volums i del volum lògic.

```bash
    --- Physical volume ---
    PV Name               /dev/nvme0n2
    VG Name               vg_webapp
    PV Size               20.00 GiB / not usable 4.00 MiB
    Allocatable           yes (but full)
    PE Size               4.00 MiB
    Total PE              5119
    Free PE               0
    Allocated PE          5119
    PV UUID               7saOpX-fjg1-afmU-ZoEA-d945-mJzN-6oo0Tl

    --- Physical Segments ---
    Physical extent 0 to 255:
        Logical volume /dev/vg_webapp/lv_sources
        Logical extents 0 to 255
    Physical extent 256 to 2815:
        Logical volume /dev/vg_webapp/lv_data
        Logical extents 0 to 2559
    Physical extent 2816 to 3071:
        Logical volume /dev/vg_webapp/lv_run
        Logical extents 0 to 255
    Physical extent 3072 to 5118:
        Logical volume /dev/vg_webapp/lv_data
        Logical extents 2560 to 4606

    --- Physical volume ---
    PV Name               /dev/nvme0n3
    VG Name               vg_webapp
    PV Size               20.00 GiB / not usable 4.00 MiB
    Allocatable           yes
    PE Size               4.00 MiB
    Total PE              5119
    Free PE               4606
    Allocated PE          513
    PV UUID               4Exs4j-Japi-ab8p-pnYx-FPNY-tKdl-KTFkHq

    --- Physical Segments ---
    Physical extent 0 to 512:
        Logical volume /dev/vg_webapp/lv_data
        Logical extents 4607 to 5119
    Physical extent 513 to 5118:
        FREE
    ```

    ```bash
    --- Logical volume ---
    LV Path                /dev/vg_webapp/lv_sources
    LV Name                lv_sources
    VG Name                vg_webapp
    LV UUID                ElTnFj-nVJT-OwhB-dTmm-l1zR-LNht-Zk8QY1
    LV Write Access        read/write
    LV Creation host, time localhost.localdomain, 2024-07-12 20:42:20 +0200
    LV Status              available
    # open                 1
    LV Size                1.00 GiB
    Current LE             256
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:2

    --- Segments ---
    Logical extents 0 to 255:
        Type    linear
        Physical volume /dev/nvme0n2
        Physical extents 0 to 255

    --- Logical volume ---
    LV Path                /dev/vg_webapp/lv_data
    LV Name                lv_data
    VG Name                vg_webapp
    LV UUID                Oliogr-YoKj-OeKh-V3jE-bcbe-i25B-fowxdT
    LV Write Access        read/write
    LV Creation host, time localhost.localdomain, 2024-07-12 20:42:25 +0200
    LV Status              available
    # open                 1
    LV Size                20.00 GiB
    Current LE             5120
    Segments               3
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:3

    --- Segments ---
    Logical extents 0 to 2559:
        Type    linear
        Physical volume /dev/nvme0n2
        Physical extents 256 to 2815

    Logical extents 2560 to 4606:
        Type    linear
        Physical volume /dev/nvme0n2
        Physical extents    3072 to 5118

    Logical extents 4607 to 5119:
        Type    linear
        Physical volume /dev/nvme0n3
        Physical extents    0 to 512

    --- Logical volume ---
    LV Path                /dev/vg_webapp/lv_run
    LV Name                lv_run
    VG Name                vg_webapp
    LV UUID                YGKTJ2-HwMi-k9CG-uyM1-wyG5-t0Vh-vGiptU
    LV Write Access        read/write
    LV Creation host, time localhost.localdomain, 2024-07-12 20:42:30 +0200
    LV Status              available
    # open                 1
    LV Size                1.00 GiB
    Current LE             256
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:4

    --- Segments ---
    Logical extents 0 to 255:
        Type    linear
        Physical volume /dev/nvme0n2
        Physical extents    2816 to 3071
```

Si analitzem les dades anteriors, podem veure que el volum lògic `lv_data` està distribuït entre els discs durs `/dev/nvme0n2` i `/dev/nvme0n3`. Això significa que si el disc dur `/dev/nvme0n3` falla, les dades emmagatzemades en aquest disc dur es perdran. Si us centreu en `/dev/vg_webapp/lv_data` veureu que els LEs 0-2559 i 2560-4606 estan en el disc dur `/dev/nvme0n2` i equivalenen als PE 256-2815 i 3072-5118. Mentre que els LEs 4607-5119 estan en el disc dur `/dev/nvme0n3` i equivalen als PE 0-512. Si fem les operacions assumint que la mida dels PE és de 4MiB i que la mida del volum lògic és de 20GB, podem veure que el disc dur `/dev/nvme0n2` conté 18GB i el disc dur `/dev/nvme0n3` conté 2GB. La traducció es pot fer utilitzant les següents operacions: $18GB = 4606 * 4MiB$ i $2GB = 512 * 4MiB$.


### Simulació de la fallada

1. Hi ha moltes maneres de simular una fallada de disc, una d'elles es corrompre la secció de metadades lvm del disc `/dev/nvme0n3`. Per fer-ho, podeu utilitzar la comanda `dd` per sobreescriure els primeres 10MB del disc dur amb zeros:

    ```bash
    dd if=/dev/zero of=/dev/nvme0n3 bs=1M count=10
    ```

    Alternativament, podeu utilitzar la comanda `wipefs` per eliminar les signatures del disc dur `/dev/nvme0n3`:

    ```bash
    wipefs --all --backup -f /dev/nvme0n3
    ```

2. Un cop hàgiu simulat la fallada del disc dur `/dev/nvme0n3`, comproveu l'estat del grup de volums `vg_webapp` i del volum lògic `lv_data`:

    ```bash
    vgdisplay vg_webapp
    lvdisplay /dev/vg_webapp/lv_data
    ```

    ```bash
    Device /dev/nvme0n3 has no PVID (devices file 4Exs4jJapiab8ppnYxFPNYtKdlKTFkHq)
    WARNING: Couldn't find device with uuid 4Exs4j-Japi-ab8p-pnYx-FPNY-tKdl-KTFkHq.
    WARNING: VG vg_webapp is missing PV 4Exs4j-Japi-ab8p-pnYx-FPNY-tKdl-KTFkHq (last written to /dev/nvme0n3).
    WARNING: Couldn't find all devices for LV vg_webapp/lv_data while checking used and assumed devices.
    ```

    A partir de la sortida anterior, podem veure que el disc dur `/dev/nvme0n3` ha fallat i que el grup de volums `vg_webapp` i el volum lògic `lv_data` tenen problemes.

    Si utilitzeu `ls -la /opt/webapp/data` o `df -h` observareu que encara podeu accedir a les dades. Recordeu que les primeres 18GB estan emmagatzemades al disc dur `/dev/nvme0n2`. Amb la comanada `pvdisplay --maps` i `lvdisplay --maps` podeu comprovar-ho veient que únicament els LEs corresponents al disc dur `/dev/nvme0n3` estan marcats com a *unknown*.

3. Ara anem a omplir el disc dur `/dev/nvme0n2` per simular una fallada imminent. Per fer-ho, podeu utilitzar la comanda `dd` per escriure 19GB de dades aleatòries a l'arxiu `/opt/webapp/data`:

    ```bash
    bash script.sh 19
    ```

    Com ha pogut guardar 19GB si el disc dur `/dev/nvme0n3` ha fallat i el disc dur `/dev/nvme0n2` només té 18GB? Això és degut a que les dades s'estan guardant en el disc dur `/dev/nvme0n2` però no s'estan actualitzant les metadades de LVM. Això pot ser un problema greu, ja que si el disc dur `/dev/nvme0n2` falla, les dades es perdran.

    Aquest fet el podeu posar de manifest intentant guardar dades al següent LE del disc dur `/dev/nvme0n2` i veureu que no es pot fer. Ja que el 1GB que ell tenia reservat s'ha omplert amb el 1GB restant de la còpia anterior.

    ```bash
    bash script.sh 1 /opt/webapp/run
    ```

    ```bash
    dd: error writing '/opt/webapp/run/file1': No space left on device
    ```

### Solucionant la fallada

Per solucionar la fallada del disc dur `/dev/nvme0n3`, seguirem els següents passos:

1. Utilitzeu l'eina `pvck` per comprovar la integritat del disc dur `/dev/nvme0n3`:

    ```bash
    pvck /dev/nvme0n3
    ```

    ```bash
    WARNING: Device for PV 4Exs4j-Japi-ab8p-pnYx-FPNY-tKdl-KTFkHq not found or rejected by a filter.
    ```

    A partir de la sortida anterior, podem veure que el disc dur `/dev/nvme0n3` no es pot trobar. Això és degut a que hem corromput les metadades de LVM del disc dur `/dev/nvme0n3`.

2. Utilitzeu l'eina `pvck` amb l'opció `--repair` per intentar reparar el disc dur `/dev/nvme0n3`:

    ```bash
    pvck --repair -f /etc/lvm/backup/vg_webapp /dev/nvme0n3
    ```

    ```bash
    CHECK: label_header.crc expected 0x5bd06dba
    CHECK: label_header.type expected LVM2 001
    WARNING: No LVM label found on /dev/nvme0n3.  It may not be an LVM device.
    Writing label_header.crc 0xc9fb4741 pv_header uuid Tqyb8i0hyzOyb2AFlgMQJ4bNW6kDiOsJ device_size 21474836480
    Writing data_offset 1048576 mda1_offset 4096 mda1_size 1044480 mda2_offset 0 mda2_size 0
    Write new LVM header to /dev/nvme0n3? y
    Writing metadata at 4608 length 2190 crc 0x38751a64 mda1
    Writing mda_header at 4096 mda1
    Write new LVM metadata to /dev/nvme0n3? y
    ```

    En aquest punt, hem intentat reparar el disc dur `/dev/nvme0n3` i hem escrit noves metadades de LVM al disc dur. El problema és que les noves metadades de LVM no coincideixen amb les metadades de LVM del grup de volums `vg_webapp`. Ho podeu comprovar amb la comanda `pvs -o+uuid`:

    ```bash
    pvs -o+uuid
    WARNING: scan of VG vg_webapp from /dev/nvme0n3 mda1 found mda_checksum 38751a64 mda_size 2190 vs d5280ec2 2174
    WARNING: Scanning /dev/nvme0n3 mda1 found mismatch with other metadata.
    WARNING: scan failed to get metadata summary from /dev/nvme0n3 PVID Tqyb8i0hyzOyb2AFlgMQJ4bNW6kDiOsJ
    Device /dev/nvme0n3 has PVID Tqyb8i0hyzOyb2AFlgMQJ4bNW6kDiOsJ (devices file none)
    WARNING: scan of VG vg_webapp from /dev/nvme0n3 mda1 found mda_checksum 38751a64 mda_size 2190 vs d5280ec2 2174
    WARNING: Scanning /dev/nvme0n3 mda1 found mismatch with other metadata.
    WARNING: scan failed to get metadata summary from /dev/nvme0n3 PVID Tqyb8i0hyzOyb2AFlgMQJ4bNW6kDiOsJ
    PV             VG        Fmt  Attr PSize   PFree  PV UUID
    /dev/nvme0n1p3 almalinux lvm2 a--   18.41g     0  59JST0-TYqg-3nyz-p4ek-MaEk-pJX6-cgGf96
    /dev/nvme0n2   vg_webapp lvm2 a--  <20.00g 17.99g 7saOpX-fjg1-afmU-ZoEA-d945-mJzN-6oo0Tl
    /dev/nvme0n3   vg_webapp lvm2 a--  <20.00g     0  Tqyb8i-0hyz-Oyb2-AFlg-MQJ4-bNW6-kDiOsJ
    ```

3. Actualitzeu les metadades del grup de volums `vg_webapp`:

    ```bash
    vgcfgrestore vg_webapp
    ```

    En aquest punt encara observareu WARNINGS, per mismatch de les metadades. Igual es pot omitir.

    ```bash

4. Actualitzeu les metadades del grup de volums `vg_webapp`:

    ```bash
    vgck --updatemetadata vg_webapp
    ```

    Amb aquesta comanda actualitzarem les metadades del grup de volums `vg_webapp` amb les noves metadades del disc dur `/dev/nvme0n3`. Ara ja no hauríeu de veure cap warning en la sortida de `pvs -o+uuid`.

### Canviant el disc

1. Ara que hem reparat el grup de volums `vg_webapp`, procedirem a canviar el disc dur `/dev/nvme0n3` per un de nou. En aquest cas, assumirem que el nou disc dur és `/dev/nvme0n4`.

2. Utilitzeu la comanda `pvcreate` per inicialitzar el disc dur `/dev/nvme0n4`:

    ```bash
    pvcreate /dev/nvme0n4
    ```

3. Utilitzeu la comanda `vgextend` per afegir el disc dur `/dev/nvme0n4` al grup de volums `vg_webapp`:

    ```bash
    vgextend vg_webapp /dev/nvme0n4
    ```

4. Utilitzeu pvmove per moure les dades del disc dur `/dev/nvme0n3` al disc dur `/dev/nvme0n4`:

    ```bash
    pvmove /dev/nvme0n3 /dev/nvme0n4
    ```

    Aquesta comanda mou les dades del disc dur `/dev/nvme0n3` al disc dur `/dev/nvme0n4`. Aquest procés pot trigar una estona depenent de la quantitat de dades a moure.

5. Utilitzeu la comanda `vgreduce` per eliminar el disc dur `/dev/nvme0n3` del grup de volums `vg_webapp`:

    ```bash
    vgreduce vg_webapp /dev/nvme0n3
    ```

6. Utilitzeu la comanda `pvremove` per eliminar el disc dur `/dev/nvme0n3` del grup de volums `vg_webapp`:

    ```bash
    pvremove /dev/nvme0n3
    ```

### Anàlisi de la situació

Creus que hi ha alguna manera de recuperar les dades del disc dur `/dev/nvme0n3`? Si la corrupció es fa a nivell de LEs en comptes de metadades. Investigar quines eines podrien ser útils per recuperar les dades del disc dur `/dev/nvme0n3`.
