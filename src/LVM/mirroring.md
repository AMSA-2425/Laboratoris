# Mirroring

Els **miralls (mirrors)** són una tècnica per protegir les dades contra la fallada d'un disc dur. Són similars als RAID 1, ja que es tracta de tenir una còpia exacta de les dades en un altre disc dur. Aquesta tècnica proporciona alta disponibilitat i protegeix les dades en cas de fallada d'un dels discs durs.

## Diferències entre mirrors i snapshots

- **Mirror**: És una còpia exacta de les dades en temps real. Si un disc falla, l'altre continua funcionant, proporcionant un duplicat exacte de les dades en tot moment.
  
- **Snapshot**: És una instantània de les dades en un moment determinat. No reflecteix canvis posteriors a la seva creació.

## Preparació

1. Utilitzeu la màquina virtual creada en els apartats anteriors.
2. Assegureu-vos que teniu dos discos durs addicionals de 20 GB adjunts a la màquina virtual, que utilitzarem per a la configuració de mirroring, en el meu cas els discs són `/dev/nvme0n3` i `/dev/nvme0n5`.

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
    ├─vg_webapp-lv_sources 253:2    0    1G  0 lvm
    ├─vg_webapp-lv_run     253:3    0    1G  0 lvm
    └─vg_webapp-lv_data    253:6    0   20G  0 lvm  /opt/webapp/data
    nvme0n3                259:5    0   20G  0 disk
    nvme0n4                259:6    0   20G  0 disk
    └─vg_webapp-lv_data    253:6    0   20G  0 lvm  /opt/webapp/data
    nvme0n5                259:7    0   20G  0 disk
    ```

## Tasques

### Creació de mirroring

1. Creeu un mirror del volum lògic `lv_data` amb un mirall:

    ```bash
    lvconvert --type mirror -m 1 /dev/vg_webapp/lv_data
    ```

    Si observeu la sortida següent, significa que no hi ha prou espai lliure per crear el mirall:

    ```bash
    Insufficient free space: 5121 extents needed, but only 4606 available
    Unable to allocate extents for mirror(s).
    ```

2. Utilitzeu un altre disc dur per ampliar el grup de volums i afegir més espai lliure:

    ```bash
    pvcreate /dev/nvme0n5
    vgextend vg_webapp /dev/nvme0n5
    ```

3. Torneu a intentar crear el mirall:

    ```bash
    lvconvert --type mirror -m 1 /dev/vg_webapp/lv_data
    ```

    I observareu que encara no hi ha prou espai lliure per crear el mirall, ja que el mirall necessita dos còpies del volum lògic que es troba repartit en dos discs diferents.

4. Utilitzeu un altre disc dur per ampliar el grup de volums i afegir més espai lliure:

    ```bash
    pvcreate /dev/nvme0n3
    vgextend vg_webapp /dev/nvme0n3
    ```

5. Torneu a intentar crear el mirall:

    ```bash
    lvconvert --type mirror -m 1 /dev/vg_webapp/lv_data
    ```

    Aquesta acció pot trigar una estona, ja que s'estan creant dues còpies del volum lògic `lv_data`. 

    ```bash
    Logical volume vg_webapp/lv_data being converted.
    vg_webapp/lv_data: Converted: 0.45%
    vg_webapp/lv_data: Converted: 100.00%
    ```

6. Observareu que s'ha creat un mirror amb dos còpies del volum lògic `lvs -a -o +devices`:

    ```bash
    LV                 VG        Attr       LSize  Pool Origin Data%  Meta%  Move Log            Cpy%Sync Convert Devices
    root               almalinux -wi-ao---- 16.41g                                                                /dev/nvme0n1p3(0)
    swap               almalinux -wi-ao----  2.00g                                                                /dev/nvme0n1p3(4201)
    lv_data            vg_webapp mwi-aom--- 20.00g                                [lv_data_mlog] 100.00           lv_data_mimage_0(0),lv_data_mimage_1(0)
    [lv_data_mimage_0] vg_webapp iwi-aom--- 20.00g                                                                /dev/nvme0n4(0)
    [lv_data_mimage_0] vg_webapp iwi-aom--- 20.00g                                                                /dev/nvme0n2(3072)
    [lv_data_mimage_1] vg_webapp iwi-aom--- 20.00g                                                                /dev/nvme0n3(0)
    [lv_data_mimage_1] vg_webapp iwi-aom--- 20.00g                                                                /dev/nvme0n5(0)
    [lv_data_mlog]     vg_webapp lwi-aom---  4.00m                                                                /dev/nvme0n2(256)
    lv_run             vg_webapp -wi-------  1.00g                                                                /dev/nvme0n2(2816)
    lv_sources         vg_webapp -wi-------  1.00g                                                                /dev/nvme0n2(0)
    ```

    - **Nota 1**: Observeu com tenim dos miralls `lv_data_mimage_0` i `lv_data_mimage_1` i cada mirall utilitza 2 discs diferents. El 0 correspont a `/dev/nvme0n4` i `/dev/nvme0n2` i el 1 a `/dev/nvme0n3` i `/dev/nvme0n5`.

    - **Nota 2**: El mirall també té un log `lv_data_mlog` que s'utilitza per mantenir la consistència dels miralls.

    - **Nota 3**: Ara si un dels discs falla, el sistema continuarà funcionant sense interrupcions a partir del mirall.
  
7. Creeu un fitxer a `/opt/webapp/data` per comprovar que el mirroring funciona correctament:

    ```bash
    echo "Hello, World!" > /opt/webapp/data/hello.txt
    ```

8. Desmunteu el mirall per comprovar que les dades es troben en els dos discs:

    ```bash
   lvconvert --splitmirrors 1 --name lv_data_backup /dev/vg_webapp/lv_data
    ```

    En aquest punt, el mirall `lv_data` s'ha dividit en dos volums lògics `lv_data` i `lv_data_backup`. Això significa que el mirall ja no està actiu i que les dades es troben en els dos volums lògics.

    ```bash
    mount /dev/vg_webapp/lv_data_backup /mnt
    cat /mnt/hello.txt
    ```

9. Elimineu el mirall `lv_data_backup`:

    ```bash
    lvremove /dev/vg_webapp/lv_data_backup
    ```

    Ara el mirall `lv_data_backup` s'ha eliminat i les dades només es troben en el volum lògic `lv_data`.

## Anàlisi

En el context dels servidors web, valora el *trade-off* entre la disponibilitat i la capacitat de disc. El mirroring és una tècnica que proporciona alta disponibilitat, ja que les dades es troben en dos discs diferents. Això significa que si un disc falla, el sistema continuarà funcionant sense interrupcions a partir del mirall. No obstant això, el mirroring també implica un cost addicional, ja que es necessiten dos discs per emmagatzemar les dades.
