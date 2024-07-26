# Desplegament d'una web amb LVM

En aquesta part de laboratori, ens centrarem en el desplegament d'una aplicació web amb **LVM**. Utilitzarem **LVM** per a gestionar tots els fitxers necessaris per al funcionament de la web, com ara el codi font, les dades, els logs i la informació dels processos i sockets utilitzat en el seu desplegament. La nostra web proporcionarà accés a informació sobre indicadors socials, econòmics i demogràfics de diferents regions del món, presentada a través d’un mapa interactiu.

- El codi font és un projecte fet amb Django que es desplegarà en el directori `/opt/webapp/source`.
- Les dades són documents, fotos, i htmls amb informació precomputada que és els usuaris de la web podran visualitzar i descarregar. Aquestes dades es guardaran en el directori `/opt/webapp/data` i també es guarden els logs de la web.
- La informació dels processos i del socket es guarda a `/opt/webapp/run`.

## Objectius

1. Compendre com utilitzar **LVM** per a gestionar els volums lògics.
2. Aprendre a gestionar els components de **LVM** com ara els volums físics, els grups de volums i els volums lògics.
3. Simular un cas real d'ús de **LVM** en un servidor web.

## Preparació

1. Inicialitzeu una nova màquina virtual amb un disc dur de 20 GB i instal·leu AlmaLinux. Utilitzeu l'instal·lador per configurar el sistema amb lvm, podeu utilitzar la configuració per defecte, o bé personalitzar-la segons les vostres necessitats. *Podeu utilitzar la màquina virtual de l'apartat anterior o no.*

2. Adjunteu dos disc dur addicionals de 20 GB a la màquina virtual.

3. Assegureu-vos que l'estat inicial del sistema és correcte. Utiltizeu la comanda `lsblk` per comprovar que teniu aquest estat inicial:

    ```bash
    NAME        MAJ:MIN RM  SIZE   RO TYPE  MOUNTPOINT
    nvme0n1     259:0    0   20G   0  disk
    ├─nvme0n1p1 259:1    0   600MB 0  part  /boot/efi
    ├─nvme0n1p2 259:2    0   1G    0  part  /boot
    ├─nvme0n1p3 259:3    0   2G    0  part  [SWAP]
    └─nvme0n1p4 259:4    0   16.4G 0  part  /
    nvme0n2     259:5    0   20G   0  disk
    nvme0n3     259:6    0   20G   0  disk
    ```

    - **Nota 1**: *El nom del dispositiu pot variar segons les vostres opcions de virtualització.*
    - **Nota 2**: En aquest cas, s'ha creat una MV nova amb 2 discos durs de 20GB cadascun.

## Tasques

### Configuració dels volums lògics

1. Creeu els volums físics amb `pvcreate`:

    ```bash
    pvcreate /dev/nvme0n2 /dev/nvme0n3
    ```

2. Analitzeu els volums físics amb `pvdisplay`:

    ```bash
    pvdisplay
    ```

    Si observeu la sortida de la comanda:

    ```bash
    "/dev/nvme0n2" is a new physical volume of "20.00 GiB"
    --- NEW Physical volume ---
    PV Name               /dev/nvme0n2
    VG Name
    PV Size               20.00 GiB
    Allocatable           NO
    PE Size               0
    Total PE              0
    Free PE               0
    Allocated PE          0
    PV UUID               D27Ox6-pKi4-1OsC-sUPE-og9f-Auvp-LB1wL1

    "/dev/nvme0n3" is a new physical volume of "20.00 GiB"
    --- NEW Physical volume ---
    PV Name               /dev/nvme0n3
    VG Name
    PV Size               20.00 GiB
    Allocatable           NO
    PE Size               0
    Total PE              0
    Free PE               0
    Allocated PE          0
    PV UUID               Arr5nq-3c89-mcw9-shxM-L27z-w2FW-fxjCD6    
    ```

    Podeu veure com s'han creat dos volums físics de 20GB cadascun. De moment, com que no s'ha creat cap grup de volums, el camp `Allocatable` està a `NO`.

3. Creeu un grup de volums anomenat `vg_webapp` amb els discs secundaris:

    ```bash
    vgcreate vg_webapp /dev/nvme0n2 /dev/nvme0n3
    ```

4. Analitzeu l'estat amb `vgdisplay` i `pvdisplay`:

    ```bash
    --- Physical volume ---
    PV Name               /dev/nvme0n2
    VG Name               vg_webapp
    PV Size               20.00 GiB / not usable 4.00 MiB
    Allocatable           yes
    PE Size               4.00 MiB
    Total PE              5119
    Free PE               5119
    Allocated PE          0
    PV UUID               D27Ox6-pKi4-1OsC-sUPE-og9f-Auvp-LB1wL1

    --- Physical volume ---
    PV Name               /dev/nvme0n3
    VG Name               vg_webapp
    PV Size               20.00 GiB / not usable 4.00 MiB
    Allocatable           yes
    PE Size               4.00 MiB
    Total PE              5119
    Free PE               5119
    Allocated PE          0
    PV UUID               Arr5nq-3c89-mcw9-shxM-L27z-w2FW-fxjCD6
    ```

    Amb el volum físic creat, ara el camp `Allocatable` està a `YES`. A més a més, podem observar com la mida dels extents és de 4MiB i el nombre total d'extents és de 5119. Aquest valors surt de dividir la mida del volum físic entre la mida de l'extens  \\( \frac{20 * 1024 MiB}{4 MiB} \\). A més a més, observem que tots els extents estan lliures.

    Ara, si analitzem el grup de volums:

    ```bash
    --- Volume group ---
    VG Name               vg_webapp
    System ID
    Format                lvm2
    Metadata Areas        2
    Metadata Sequence No  1
    VG Access             read/write
    VG Status             resizable
    MAX LV                0
    Cur LV                0
    Open LV               0
    Max PV                0
    Cur PV                2
    Act PV                2
    VG Size               39.99 GiB
    PE Size               4.00 MiB
    Total PE              10238
    Alloc PE / Size       0 / 0
    Free  PE / Size       10238 / 39.99 GiB
    VG UUID               NAyZgb-ceve-Fsfa-YrLX-l9eg-rg4W-2Ur02H
    ```

    Podem veure com el grup de volums `vg_webapp` té un total de 39.99 GiB i tots els extents estan lliures. A més a més, observem que tenim permisos de lectura i escriptura i que el grup de volums és resizable.

5. Creeu els volums lògics necessaris per a la configuració del nostre servei web:

    - Guardar el codi font de la web:

        ```bash
        lvcreate -L 1G -n lv_sources vg_webapp
        ```

    - Guardar les dades estatístiques de la web:

        ```bash
        lvcreate -L 10G -n lv_data vg_webapp
        ```

    - Guardar la informació de run-time de la web:

        ```bash
        lvcreate -L 1G -n lv_run vg_webapp
        ```

6. Analitzeu un altre cop l'estat amb les comandes  `vgdisplay` i `lvdisplay`:

    ```bash
    --- Volume group ---
    VG Name               vg_webapp
    System ID
    Format                lvm2
    Metadata Areas        2
    Metadata Sequence No  4
    VG Access             read/write
    VG Status             resizable
    MAX LV                0
    Cur LV                3
    Open LV               0
    Max PV                0
    Cur PV                2
    Act PV                2
    VG Size               39.99 GiB
    PE Size               4.00 MiB
    Total PE              10238
    Alloc PE / Size       3072 / 12.00 GiB
    Free  PE / Size       7166 / 27.99 GiB
    VG UUID               NAyZgb-ceve-Fsfa-YrLX-l9eg-rg4W-2Ur02H
    ```

    La principal diferència és que ara tenim 3 volums lògics creats i que s'han reservat 3072 extents per a 12 GiB. Aquestes 12 GiB corresponen a la suma dels tres volums lògics (1GB + 10GB + 1GB). Cada volum lògic té un total de 1024 extents. Per tant, el total de extents reservats és de 3072.

    Un altre punt interesant són els atributs Metadata Areas i Metadata Sequence No. Metadata Areas ens indica el nombre de discos on es guarda la informació de LVM. En aquest cas, tenim 2 discos. Metadata Sequence No ens indica el nombre de vegades que s'ha modificat el grup de volums. Abans de crear els volums lògics, el grup de volums tenia un Metadata Sequence No de 1 i Metadata Areas de 2. Després de crear els volums lògics, el Metadata Sequence No ha canviat a 4 i el Metadata Areas segueix sent 2.

    ```bash
    --- Logical volume ---
    LV Path                /dev/vg_webapp/lv_sources
    LV Name                lv_sources
    VG Name                vg_webapp
    LV UUID                WmJB46-zWcR-xPt3-cD8K-fxeT-KFya-WGEa6e
    LV Write Access        read/write
    LV Creation host, time localhost.localdomain, 2024-07-12 14:09:53 +0200
    LV Status              available
    # open                 0
    LV Size                1.00 GiB
    Current LE             256
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:2

    --- Logical volume ---
    LV Path                /dev/vg_webapp/lv_data
    LV Name                lv_data
    VG Name                vg_webapp
    LV UUID                VfILMu-Pd5N-P0Pt-MLd0-Edur-qIdv-hZcaYs
    LV Write Access        read/write
    LV Creation host, time localhost.localdomain, 2024-07-12 14:10:13 +0200
    LV Status              available
    # open                 0
    LV Size                10.00 GiB
    Current LE             2560
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:3

    --- Logical volume ---
    LV Path                /dev/vg_webapp/lv_run
    LV Name                lv_run
    VG Name                vg_webapp
    LV UUID                BJAdkW-nUGT-zT9f-5wIV-Ya6R-Cr4n-aYX394
    LV Write Access        read/write
    LV Creation host, time localhost.localdomain, 2024-07-12 14:10:22 +0200
    LV Status              available
    # open                 0
    LV Size                1.00 GiB
    Current LE             256
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:4
    ```

    Podem veure com cada volum lògic té un tamany de 1 GiB, 10 GiB i 1 GiB respectivament. A més a més, cada volum lògic té un total de 256 extents. Això és degut a que la mida de l'extens és de 4 MiB i el tamany de cada volum lògic és de 1 GiB. Per tant, el nombre d'extents necessaris per a cada volum lògic és de \\(  \frac{1024}{4} = 256  \\) i en el cas del volum lògic de 10 GiB és de \\( \frac{10240}{4} = 2560 \\) extents.

    Un altre punt interessant és el Block device. Aquesta informació ens indica el dispositiu de bloc associat a cada volum lògic. En aquest cas, tenim els dispositius de bloc 253:2, 253:3 i 253:4 per als volums lògics lv_sources, lv_data i lv_run respectivament.

7. Formateu els volums lògics amb el sistema de fitxers:

    - Volum lògic de la web:

        ```bash
        mkfs.xfs /dev/vg_webapp/lv_sources
        ```

    - Volum lògic de les dades:

        ```bash
        mkfs.ext4 /dev/vg_webapp/lv_data
        ```

    - Volum lògic de run-time:

        ```bash
        mkfs.xfs /dev/vg_webapp/lv_run
        ```

8. Munteu els volums lògics en els directoris corresponents:

    - Crearem un directori a `/opt` per muntar el volum lògic de la web:

        ```bash
        mkdir /opt/webapp
        ```

    - Volum lògic de la web:

        ```bash
        mkdir /opt/webapp/sources
        mount /dev/vg_webapp/lv_sources /opt/webapp/sources
        ```

    - Volum lògic de les dades:

        ```bash
        mkdir /opt/webapp/data
        mount /dev/vg_webapp/lv_data /opt/webapp/data
        ```

    - Volum lògic de run-time:

        ```bash
        mkdir /opt/webapp/run
        mount /dev/vg_webapp/lv_run /opt/webapp/run
        ```

    **Recordeu**: Els volums es muntaran de forma temporal al servidor. Per a muntar-los de forma permanent, heu d'afegir les entrades corresponents al fitxer `/etc/fstab`.

9. Analitzeu l'estat del servidor:

   ```bash
   [root@localhost ~]# lsblk
    NAME                   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
    sr0                     11:0    1  1.7G  0 rom
    nvme0n1                259:0    0   20G  0 disk
    ├─nvme0n1p1            259:1    0  600M  0 part /boot/efi
    ├─nvme0n1p2            259:2    0    1G  0 part /boot
    └─nvme0n1p3            259:3    0 18.4G  0 part
    ├─almalinux-root     253:0    0 16.4G  0 lvm  /
    └─almalinux-swap     253:1    0    2G  0 lvm  [SWAP]
    nvme0n2                259:4    0   20G  0 disk
    ├─vg_webapp-lv_sources 253:2    0    1G  0 lvm  /opt/webapp/sources
    ├─vg_webapp-lv_data    253:3    0   10G  0 lvm  /opt/webapp/data
    └─vg_webapp-lv_run     253:4    0    1G  0 lvm  /opt/webapp/run
    nvme0n3                259:5    0   20G  0 disk
    ```

    Podem veure com s'han muntat els volums lògics en els directoris corresponents. El volum lògic de la web s'ha muntat a `/opt/webapp/sources`, el volum lògic de les dades s'ha muntat a `/opt/webapp/data` i el volum lògic de run-time s'ha muntat a `/opt/webapp/run`. A més a més, com estem utiltizant un LVM lineal, podem veure com únicament utilitzem un disc dur per a guardar les dades. Ja que encara no hem superat la seva capacitat.

### Actualització dels volums lògics

En aquest punt, ens hem adonat que les dades de la web són superior a 10GB. Però tenim 28GB disponibles al nostre volum lògic de dades. Per tant, volem augmentar el tamany del volum lògic de les dades a 20GB. Ho podeu veure amb la comanda `vgs`:

```bash
  VG        #PV #LV #SN Attr   VSize  VFree
  almalinux   1   2   0 wz--n- 18.41g     0
  vg_webapp   2   3   0 wz--n- 39.99g 27.99g
```

1. Augmenteu el tamany del volum lògic de les dades a 20GB.

    ```bash
    lvextend -L +10G /dev/vg_webapp/lv_data
    ```

2. Redimensioneu el sistema de fitxers:

    ```bash
    resize2fs /dev/vg_webapp/lv_data
    ```

    **Nota:** Aquest pas es essecnial, ja que si no redimensionem el sistema de fitxers, el sistema operatiu no podrà accedir a l'espai addicional i no podrà utilitzar-lo. Per a `xfs` utilitzariam la comanda `xfs_growfs`.

3. Analitzeu l'estat del servidor:

    ```bash
    NAME                   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
    sr0                     11:0    1  1.7G  0 rom
    nvme0n1                259:0    0   20G  0 disk
    ├─nvme0n1p1            259:1    0  600M  0 part /boot/efi
    ├─nvme0n1p2            259:2    0    1G  0 part /boot
    └─nvme0n1p3            259:3    0 18.4G  0 part
    ├─almalinux-root     253:0    0 16.4G  0 lvm  /
    └─almalinux-swap     253:1    0    2G  0 lvm  [SWAP]
    nvme0n2                259:4    0   20G  0 disk
    ├─vg_webapp-lv_sources 253:2    0    1G  0 lvm  /opt/webapp/sources
    ├─vg_webapp-lv_data    253:3    0   20G  0 lvm  /opt/webapp/data
    └─vg_webapp-lv_run     253:4    0    1G  0 lvm  /opt/webapp/run
    nvme0n3                259:5    0   20G  0 disk
    └─vg_webapp-lv_data    253:3    0   20G  0 lvm  /opt/webapp/data
    ```

    Observeu com ara el volum lògic de les dades té un tamany de 20GB i el disc dur `nvme0n2`no té sufiticient espai per a guardar les dades. Per tant, es necessita utilitzar part del disc dur `nvme0n3` i `nvme0n2` per gestionar la partició de les dades.

Després d'un temps, utilitzant la web, ens hem adonat que la partició `lv_run`esta sobredimensionada i únicament s'utilitza un 10% del seu espai. Per tant, volem reduir el tamany de la partició `lv_run` a 500MB. Alliberant així 500MB per a altres particions.

1. Reduïu el tamany del volum lògic de run-time a 500MB:

    ```bash
    lvreduce -L 500M /dev/vg_webapp/lv_run
    ```

    Observeu que LVM no us permetrà realitzar aquesta acció. El sistema de fitxers `xfs` té una mida de 1GB i no permet reduir el tamany del volum lògic.

    ```bash
    File system xfs found on vg_webapp/lv_run mounted at /opt/webapp/run.
    File system size (1.00 GiB) is larger than the requested size (500.00 MiB).
    File system reduce is required and not supported (xfs).
    ```

2. Redimensioneu el sistema de fitxers `xfs` a 500MB:

    El principal problema és que el sistema de fitxers `xfs` no permet reduir el tamany. La manera de dur a terme aquesta reducció seria: a. Muntar un disc dur addicional, b. Copiar les dades a aquest disc dur, c. Desmuntar el volum lògic, d. Eliminar el volum lògic, e. Crear un nou volum lògic de 500MB, f. Formateu el volum lògic amb el sistema de fitxers `xfs`, g. Munteu el volum lògic en el directori corresponent i h. Copiar les dades al nou volum lògic.

    Com en aquest cas no tenim dades, podem fer el següent:

    - Desmuntar el volum lògic:
  
        ```bash
        umount /opt/webapp/run
        ```

    - Eliminar el volum lògic:

        ```bash
        lvremove /dev/vg_webapp/lv_run
        ```

    - Crear un nou volum lògic de 500MB:

        ```bash
        lvcreate -L 500M -n lv_run vg_webapp
        ```

        En aquest punt, el sistema detectarà que hi ha un sistema de fitxers `xfs` al volum lògic i us preguntarà si voleu eliminar-lo. Respongueu `y` per a eliminar el sistema de fitxers `xfs`. Això és deu a que `lvremove` no elimina el sistema de fitxers, únicament el volum lògic.

        ```bash
        WARNING: xfs signature detected on /dev/vg_webapp/lv_run at offset 0. Wipe it? [y/n]: y
        Wiping xfs signature on /dev/vg_webapp/lv_run.
        Logical volume "lv_run" created.
        ```

    - Formateu el volum lògic amb el sistema de fitxers `xfs`:

        ```bash
        mkfs.xfs -f /dev/vg_webapp/lv_run
        ```

    - Munteu el volum lògic en el directori corresponent:

        ```bash
        mount /dev/vg_webapp/lv_run /opt/webapp/run
        ```

    - **Nota 1**: Aquest pas sempre és mes complex. Per tant, la meva recomanació és intentar assignar espai a la baixa, ja que incrementar l'espai és més fàcil que reduir-lo.

    - **Nota 2**: Altres sistemes de fitxers com `ext4` permeten reduir el tamany del volum lògic sense problemes, simplificant així aquest procés.

3. Analitzeu l'estat del servidor amb `lvs`:

    ```bash
    LV         VG               Attr       LSize   
    root       almalinux        -wi-ao----  16.41g
    swap       almalinux        -wi-ao----   2.00g
    lv_data    vg_webapp        -wi-ao----  20.00g
    lv_run     vg_webapp        -wi-ao---- 500.00m
    lv_sources vg_webapp        -wi-ao----   1.00g
    ```

    Podem observar com s'ha reduït el tamany del volum lògic de run a 500MB.

## Anàlisi del sistema

Es demana que analitzeu la següent aplicació web i indiqueu si la configuració de lvm és òptima. Justifiqueu la vostra resposta. La aplicació web és un blog amb les següents característiques:

- La pàgina rep 1000 visites diàries.
- La pàgina conté documents que s’acostumen a consultar de forma massiva i simultània.
- Es generen 1 GB de logs cada dia.
- Es generen 5 GB de dades estátiques noves cada mes.

Podeu assumir que cada mes es volquen tots els logs en una base de dades externa i que s’allibera l’espai dels logs.
