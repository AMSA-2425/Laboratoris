# Anàlisi dels modes striped i linear

Abans de procedir amb la migració completa, realitzeu una prova amb un disc dur utilitzant un volum lògic en mode striped i un altre en mode linear. L’objectiu és comparar el rendiment de cada mode i analitzar quin dels dos ens convé més per a la nostra configuració.

## Objectius

1. Pràctica les comandes bàsiques de LVM.
2. Observar les diferències entre els modes striped i linear en LVM.
3. Apendre a fer analisis de rendiment d'operació d'entrada/sortida amb `fio`.

## Preparació

1. Inicialitzeu una nova màquina virtual amb un disc dur de 20 GB i instal·leu AlmaLinux. Podeu fer servir el sistema de particions tradicionals per defecte. *Podeu seguir el procediment descrit a les diapositives de classe.*

2. Adjunteu dos disc dur addicionals de 10 GB a la màquina virtual. Aquests discs dur s’utilitzaràn per a crear els volums lògics en mode striped i linear i comparar-ne el rendiment.

3. Assegureu-vos que l'estat inicial del sistema és correcte. Utiltizeu la comanda `lsblk` per comprovar que teniu aquest estat inicial:

    ```bash
    NAME        MAJ:MIN RM  SIZE   RO TYPE  MOUNTPOINT
    nvme0n1     259:0    0   20G   0  disk
    ├─nvme0n1p1 259:1    0   600MB 0  part  /boot/efi
    ├─nvme0n1p2 259:2    0   1G    0  part  /boot
    ├─nvme0n1p3 259:3    0   2G    0  part  [SWAP]
    └─nvme0n1p4 259:4    0   16.4G 0  part  /
    nvme0n2     259:5    0   10G   0  disk
    nvme0n3     259:6    0   10G   0  disk
    ```

    **Nota**: *El nom del dispositiu pot variar segons les vostres opcions de virtualització.*

## Tasques

1. Inicialitzeu els disc dur secundaris amb `pvcreate`, modifiqueu l'etiqueta dels discs en funció del vostre sistema de virtualització. En cas de dubte, podeu utilitzar la comanda `lsblk` per identificar-los.

    ```bash
    ~pvcreate /dev/nvme0n2 /dev/nvme0n3
    ```

2. Creeu un grup de volums anomenat `vg0` amb el discs secundaris.

    ```bash
    ~vgcreate vg0 /dev/nvme0n2 /dev/nvme0n3
    ```

3. Creeu 2 volums lògics, un en mode striped i un altre en mode linear.

    - Mode striped: Utilitzeu la comanda `lvcreate` per crear un volum lògic en mode striped amb 2 extends i un tamany de 5GB.

        ```bash
        ~lvcreate -L 5G -n lv_striped -i 2 vg0
        ```

    - Mode linear: Utilitzeu la comanda `lvcreate` per crear un volum lògic en mode linear amb un tamany de 5GB.

        ```bash
        ~lvcreate -L 5G -n lv_linear vg0
        ```

4. Visualització de volums lògics: Ara comprovarem les característiques dels volums lògics creats. Per fer-ho, utilitzeu la comanda `lvs` i personalitzeu la seva sortida per mostrar només el nom del volum lògic, el tipus de volum lògic, el tamany, el nombre de stripes, el rang de segments i el tamany del segment. A més, filtreu la llista per mostrar només els volums lògics que pertanyen al grup de volums `vg0`.

   ```bash
    lvs -o lv_name,lv_attr,lv_size,stripes,seg_le_ranges,seg_size_pe -S vg_name=vg0
    ```

5. Formateu els volums lògics amb el sistema de fitxers `ext4`.

    - Volum lògic en mode striped:
  
        ```bash
        ~mkfs.ext4 /dev/vg0/lv_striped
        ```

    - Volum lògic en mode linear:

        ```bash
        ~mkfs.ext4 /dev/vg0/lv_linear
        ```

6. Munteu els volums lògics en els directoris `/mnt/striped` i `/mnt/linear`.

    - Volum lògic en mode striped:

        ```bash
        ~mkdir /mnt/striped
        ~mount /dev/vg0/lv_striped /mnt/striped
        ```

    - Volum lògic en mode linear:

        ```bash
        ~mkdir /mnt/linear
        ~mount /dev/vg0/lv_linear /mnt/linear
        ```

7. Avaluació del rendiment d’escriptura: Utilitzeu el programa `dd` per escriure un arxiu de 1GB en cada volum lògic i avaluar el rendiment de les operacions d’escriptura.

    ```bash
    dd if=/dev/zero of=/mnt/striped/file bs=1M count=1024
    ```

    ```bash
    # 1024+0 records in
    # 1024+0 records out
    # 1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.369798 s, 2.9 GB/s
    ```

    ```bash
    dd if=/dev/zero of=/mnt/linear/file bs=1M count=1024
    ```

    ```bash
    # 1024+0 records in
    # 1024+0 records out
    # 1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.558201 s, 1.9 GB/s
    ```

    En els resultats obtinguts es pot veure que el volum lògic en mode striped té un rendiment superior al volum lògic en mode linear. En el mode **striped**, les dades es distribueixen entre tots els discs disponibles, permetent que les operacions d’escriptura es realitzin en *paral·lel*. En canvi, en el mode **linear**, les dades es guarden *seqüencialment* en un disc fins que s’omple, i llavors comencen a guardar-se en el següent disc. Això significa que les operacions d’escriptura  només es poden realitzar en un disc a la vegada. En el nostre cas, com que tenim dos discs el seu rendiment és el doble que en mode linear.

    Podem observar aquest comportament amb l'eina `iostat`. Per fer-ho obriu 2 terminals:

    ```bash
    # Terminal 1
    iostat -hx /dev/nvme0n2 /dev/nvme0n3 1
    ```

    ```bash
    # Terminal 2
    dd if=/dev/zero of=/mnt/striped/file bs=1M count=1024
    ```

    **Nota**: Per instal·lar `iostat` executeu `dnf install sysstat -y`.

    Observareu la columna **(w/s)** on s'indica el nombre d'operacions d'escriptura per segon. En cada disc tenim 476 operacions d'escriptura per segon, durant la realització del `dd`.

    ```bash
    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.0%    0.0%   22.2%    0.0%    0.0%   77.8%

        r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz Device
        0.00      0.0k     0.00   0.0%    0.00     0.0k nvme0n2
        0.00      0.0k     0.00   0.0%    0.00     0.0k nvme0n3

        w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz Device
    467.00    460.0M  6899.00  93.7%    0.80  1008.7k nvme0n2
    467.00    460.0M  6901.00  93.7%    0.78  1008.7k nvme0n3

        d/s     dkB/s   drqm/s  %drqm d_await dareq-sz Device
        0.00      0.0k     0.00   0.0%    0.00     0.0k nvme0n2
        0.00      0.0k     0.00   0.0%    0.00     0.0k nvme0n3
    ```

## Anàlis del rendiment

En aquest apartat, es demana elaborar un informe tècnic que respongui a les següents preguntes:

- En aquest apartat es demana que analitzeu diferents *workloads* i analitzeu el rendiment de cada volum lògic durant les operacions de lectura i escriptura. Per fer-ho, utilitzarem l'eina `fio` per simular diferents càrregues de treball. Per instal·lar `fio` executeu `dnf install fio -y`. Un cop instal·lat, creareu una carpeta per guardar els *workloads*; `mkdir /tmp/workloads`.

  - **Workload 1**:

    ```bash
    echo " [global]
    direct=1
    ioengine=libaio
    bs=4k
    iodepth=16
    runtime=60
    size=5g
    filename=testfile

    [read-seq]
    rw=read
    stonewall" > /tmp/workloads/read-seq-4k.fio
    ```

  - **Workload 2**:

    ```bash
    echo " [global]
    direct=1
    ioengine=libaio
    bs=128k
    iodepth=16
    runtime=60
    size=5g
    filename=testfile

    [read-random]
    rw=randread
    stonewall" > /tmp/workloads/read-rand-128k.fio
    ```

    Per executar el *workload*:

    ```bash
    # Linear
    fio /tmp/workloads/read-seq.fio --filename=/mnt/linear/testfile
    fio /tmp/workloads/read-rand.fio --filename=/mnt/linear/testfile
    # Striped
    fio /tmp/workloads/read-seq.fio --filename=/mnt/striped/testfile
    fio /tmp/workloads/read-rand.fio --filename=/mnt/striped/testfile
    ```

    Centreu-vos en els valors IOPS, BW i temps de finalització del *workload*. Analitzeu els resultats de forma argumentada. Comentant l'impacte de la mida del bloc **bs** i operacions de lectura seqüencial i aleatòria. *Es recomanable, generar el workload 3 i 4 amb la resta de opcions per veure els efectes*.

- Assumint els workloads anteriors dissenyeu un experiment utiltizant per generar una gràfica que mostri el rendiment del volum striped configurat amb diferents valors `stripsize` (64K, 128K, 256K, 512K, 1M i 2M).

## Neteja

Un cop finalitzat el laboratori, eliminarem tots els recursos creats:

1. Eliminar les dades crades:

    ```bash
    ~rm -rf /mnt/striped /mnt/linear
    ```

2. Desmontar els volums lògics:

    ```bash
    ~umount /mnt/striped /mnt/linear
    ```

3. Eliminar els volums lògics:

    ```bash
    ~lvremove /dev/vg0/lv_striped /dev/vg0/lv_linear
    ```

4. Eliminar el grup de volums:

    ```bash
    ~vgremove vg0
    ```

5. Eliminar els volums físics:

    ```bash
    ~pvremove /dev/nvme0n2 /dev/nvme0n3
    ```

6. Elimineu la màquina virtual i tots els recursos associats.
