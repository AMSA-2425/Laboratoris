# Snapshots

En la nostra infraestructura, la *seguretat de les dades* és un aspecte fonamental. Per això, és crucial disposar de mecanismes que ens permetin **recuperar la informació** en cas de *pèrdua o corrupció*. Un d’aquests mecanismes són les **instantànies (snapshots)**, que ens permeten fer *còpies de seguretat dels nostres volums lògics en un moment determinat sense interrompre el servei*. Aquesta funcionalitat és possible gràcies a la tècnica de COW (copy-on-write) de LVM, que clona les dades originals abans de ser modificades.

Un cas d'ús comú, per exemple, en el nostre servei web, seria per realitzar una còpia de seguretat de la carpeta de dades abans de realitzar un canvi important. Una opció seria comprimir tots els fitxers de `/opt/web/data` en un arxiu tar i desar-lo en un directori de backup. No obstant això, com la web està en funcionament, els fitxers poden canviar durant el procés de compressió, cosa que podria provocar un error de 'file was changed as we read it'. Per evitar aquest problema, podem utilitzar snapshots per fer una còpia de seguretat dels fitxers en un moment determinat, sense interrompre el servei.

1. **Creació de snapshots**: Crearem un snapshot del volum lògic `/dev/vg_webapp/lv_data` per fer una còpia de seguretat dels fitxers de la carpeta `/opt/webapp/data`.
2. **Crearem una còpia de la informació**: Crearem una còpia de la informació llegint l'snapshot que hem creat, mentre el volum lògic original està en funcionament i els usuaris continuen treballant.
3. **Mourem la còpia de seguretat**: Mourem la còpia de seguretat a un altre servidor o sistema de backup.
4. **Neteja**: Un cop hem acabat la còpia de seguretat, eliminarem l'snapshot.

## Preparació

1. Utilitzeu la màquina virtual creada en els apartats anteriors.
2. Assegureu-vos que teniu el volum lògic `/dev/vg_webapp/lv_data` creat i muntat en el directori `/opt/webapp/data`.
3. Elimineu els fitxers de prova de la carpeta `/opt/webapp/data`:

    ```bash
    rm -rf /opt/webapp/data
    ```

4. Creeu dades de prova en el directori `/opt/webapp/data`:

    ```bash
    echo "Hello, World1!" > /opt/webapp/data/file1.txt
    echo "Hello, World2!" > /opt/webapp/data/file2.txt
    echo "Hello, World3!" > /opt/webapp/data/file3.txt
    ```

## Tasques

### Creació d'snapshots

El primer pas per realitzar una còpia de seguretat dels nostres fitxers, creant un snapshot del volum lògic `/dev/vg_webapp/lv_data`.

1. Creeu un snapshot del volum lògic `/dev/vg_webapp/lv_data`:

    ```bash
    lvcreate -L 1G -s -n snap_data /dev/vg_webapp/lv_data
    ```

    **Nota**: La mida d'un snapshot hauria de ser suficient per guardar els fitxers actuals del volum lògic. Per tant, és important ajustar la mida de l'snapshot segons les necessitats del nostre sistema. En aquest laboratori, assumirem que 1GB és suficient per a les nostres dades.

    Si tot ha anat bé, hauríeu de veure un missatge com aquest:

    ```bash
    Logical volume "snap_data" created.
    ```

2. Comproveu que l'snapshot s'ha creat correctament:

    ```bash
    lvs
    ```

    Aquesta comanda us mostrarà informació rellevant sobre l'snapshot:

    ```bash
    LV        VG        Attr       LSize Pool Origin  Data%
    snap_data vg_webapp swi-a-s--- 1.00g      lv_data 0.01
    ```

    On `snap_data` és el nom de l'snapshot, `vg_webapp` és el grup de volums, `swi-a-s---` són els atributs de l'snapshot:
    - (s): és un snapshot
    - (w): té permisos d'escriptura
    - (i): indica que és un volum lògic heretat, és a dir, que depèn d'un altre volum lògic.
    - (a): indica que el volum lògic està actiu

    Si us fixeu, entre `a-s` indica que el dispositiu (snapshot) no ha estat obert, ja que no està muntat. Ho podeu comprovar amb el volum lògic original `/dev/vg_webapp/lv_data` que està muntat.

    La columna `Data` indica el percentatge de dades que conté l'snapshot. `1.00g` és la mida de l'snapshot, `lv_data` és el volum lògic original, `0.01` és el percentatge de dades que conté l'snapshot.

3. Creeu un punt de muntatge per a l'snapshot:

    ```bash
    mkdir /snaps
    ```

4. Munteu l'snapshot en el directori `/snaps`:

    ```bash
    mount /dev/vg_webapp/snap_data /snaps
    ```

5. Comproveu amb `lvs` com ara l'snapshot està muntada: `swi-aos---`.

    ```bash
    lvs
    ```

6. Compareu el contingut del directori `/opt/webapp/data` amb el de l'snapshot:

    ```bash
    diff -r /opt/webapp/data /snaps
    ```

    En aquest punt, els dos directoris haurien de ser idèntics. Per tant, no s'hauria de mostrar cap sortida.

7. Reviseu els atributs de la carpeta `/snaps` i `/opt/webapp/data` mostrant informació dels inodes:

    ```bash
    ls -li /opt/webapp/data /snaps/
    ```

   Cal destacar que un *snapshot* conté enllaços **físics** als **inodes reals de les dades**. Això significa que, mentre les dades no canviïn, l' *snapshot* només contindrà referències als fitxers originals. No obstant això, si les dades del volum original es modifiquen, l'*snapshot* clonarà automàticament la informació abans de ser modificada, mantenint els fitxers originals a l'*snapshot* i les dades noves al sistema de fitxers actiu. A més, les dades que s'escriuen a l'*snapshot* es marquen com a utilitzades i no es copien al volum original.
 
    ```bash
    /opt/webapp/data:
    total 12
    11 -rw-r--r--. 1 root root 15 Jul 16 09:26 file1.txt
    12 -rw-r--r--. 1 root root 15 Jul 16 09:26 file2.txt
    13 -rw-r--r--. 1 root root 15 Jul 16 09:26 file3.txt
    
    /snaps/:
    total 12
    11 -rw-r--r--. 1 root root 15 Jul 16 09:26 file1.txt
    12 -rw-r--r--. 1 root root 15 Jul 16 09:26 file2.txt
    13 -rw-r--r--. 1 root root 15 Jul 16 09:26 file3.txt
    ```

8. Modifiqueu el fitxer `file3.txt` amb la comanda `dd` per escriure-hi un nou contingut (per exemple, 100MB de zeros):

   ```bash
    dd if=/dev/zero of=/opt/webapp/data/file3.txt bs=1M count=100
    ```

9. Compareu de nou el contingut del directori `/opt/webapp/data` amb el de l'snapshot:

    ```bash
    diff -r /opt/webapp/data /snaps
    ```

    En aquest punt, els dos directoris haurien de ser diferents. Per tant, hauríeu de veure les diferencies amb la comanda `diff`.

    ```bash
    Binary files /opt/webapp/data/file3.txt and /snaps/file3.txt differ
    ```

10. Realitzeu, un nou snapshot del volum lògic `/dev/vg_webapp/lv_data`, i després modifiqueu el fitxer `file2.txt`:

    ```bash
    lvcreate -L 1G -s -n snap_data2 /dev/vg_webapp/lv_data && dd if=/dev/zero of=/opt/webapp/data/file2.txt bs=1M count=100
    ```

11. Desmuntem el primer snapshot:

    ```bash
    umount /snaps
    ```

12. Muntem el segon snapshot:

    ```bash
    mount /dev/vg_webapp/snap_data2 /snaps
    ```

13. Compareu  de nou els atributs de la carpeta `/snaps`:

    ```bash
    ls -li /opt/webapp/data /snaps/
    ```

    ```bash
    /opt/webapp/data:
    total 204804
    11 -rw-r--r--. 1 root root        15 Jul 16 17:39 file1.txt
    12 -rw-r--r--. 1 root root 104857600 Jul 16 17:40 file2.txt
    13 -rw-r--r--. 1 root root 104857600 Jul 16 17:40 file3.txt

    /snaps/:
    total 102408
    11 -rw-r--r--. 1 root root        15 Jul 16 17:39 file1.txt
    12 -rw-r--r--. 1 root root        15 Jul 16 17:39 file2.txt
    13 -rw-r--r--. 1 root root 104857600 Jul 16 17:40 file3.txt
    ```

    Fixeu-vos que el fitxer `file2.txt` de  l'snapshot no ha canviat, ja que les dades originals s'han clonat abans de ser modificades. En canvi, el fitxer `file2.txt` del directori `/opt/webapp/data` ha canviat. Tot i això, segueixen tenint el mateix inode. Això és possible gràcies a la funcionalitat de COW (copy-on-write) dels snapshots.

En aquest punt, podria'm realitzar una còpia de seguretat de la carpeta `/opt/webapp/data` sense interrompre el servei. Es podria utilitzar les eines `cp` o `rsync` per copiar els fitxers de l'snapshot a un altre sistema de backup. 

### Recuperant dades de l'snapshot

Imaginem que el fitxer `file2.txt` s'han incorporat canvis incorrectes i volem restaurar la versió original. Per fer-ho, utilitzarem el segon snapshot `snap_data2` que hem creat anteriorment.

1. Desmuntem el volum lògic original:

    ```bash
    umount /dev/vg_webapp/lv_data
    ```

    **Nota**: Aquest punt provocarà una interrupció del servei, ja que el volum lògic original està en ús.

2. Fusionem l'snapshot amb el volum lògic original:

    ```bash
    lvconvert --merge /dev/vg_webapp/snap_data2
    ```

    ```bash
    Merging of volume vg_webapp/snap_data2 started.
    vg_webapp/lv_data: Merged: 90.73%
    vg_webapp/lv_data: Merged: 100.00%
    ```

    **Nota**: Aquest procés pot trigar una estona, ja que implica la fusió de les dades de la snapshot amb el volum lògic original.

3. Montem el volum lògic original:

    ```bash
    mount /dev/vg_webapp/lv_data /opt/webapp/data
    ```

4. Comproveu que el fitxer `file2.txt` ha estat restaurat:

    ```bash
    ls -l /opt/webapp/data
    ```

Aquesta acció ha implicat aturar el servei durant un temps, ja que hem hagut de desmuntar el volum lògic original per fusionar-lo amb l'snapshot. Aquesta és una de les **limitacions dels snapshots de LVM**.

### Propietats dels snapshots

Fins ara, hem vist com crear i utilitzar snapshots. Ara bé, un error comú es no tenir en compte que tot i que els snapshots no són **incrementals**, si que són **diferencials**. Això vol dir que els snapshots no guarden totes les versions anteriors de les dades, sinó només les diferències amb les dades originals. Aquesta característica ens permet registrar les diferències entre les dades originals i els snapshots, però no tenir un històric dels canvis. Això es deu a la tècnica de COW (copy-on-write) que utilitza LVM per als snapshots. Aquesta tècnica clona les dades originals abans de ser modificades.Ara bé, les dades originals es clonen només si es modifiquen, i l'únic que es clona és el bloc de dades modificat.

1. Comproveu l'estat inicial del lv i de l'snapshot amb la comanda `lvs`:

    ```bash
    LV        VG        Attr       LSize Pool Origin  Data% lv_data   vg_webapp owi-aos--- 1.00g
    snap_data vg_webapp swi-a-s--- 1.00g      lv_data 0.01
    ```

2. Afegiu un nou fitxer de 100MB al directori `/opt/webapp/data`:

    ```bash
    dd if=/dev/zero of=/opt/webapp/data/file4.txt bs=1M count=100 oflag=dsync
    ```

3. Comproveu amb `lvs` l'estat del volum lògic i de l'snapshot:

    ```bash
    LV         VG        Attr       LSize  Pool Origin  Data% 
    root       almalinux -wi-ao---- 16.41g
    swap       almalinux -wi-ao----  2.00g
    lv_data    vg_webapp owi-aos--- 20.00g
    lv_run     vg_webapp -wi-a-----  1.00g
    lv_sources vg_webapp -wi-a-----  1.00g
    snap_data  vg_webapp swi-a-s---  1.00g      lv_data 10.00
    ```

    Fixeu-vos que la columna `Data` de l'snapshot ha augmentat al 10%. Això indica que l'snapshot ha registrat els canvis que hem fet al volum lògic original. Però, tal com hem vist abans, aquest fitxer no es pot visualitzar si munteu l'snapshot i comproveu el seu contingut. Això és perquè els snapshots de LVM són diferencials, no incrementals.

4. Per actualitzar el contingut de l'snapshot, hauriam d'eliminar-lo i crear-ne un de nou:

    ```bash
    lvremove /dev/vg_webapp/snap_data
    lvcreate -L 1G -s -n snap_data /dev/vg_webapp/lv_data
    ```

Molts us preguntareu, si no puc recuperar o veure les modificacions sense crear-ne un de nou i a més l'snapshot ocupa espai per les diferencia, quin  sentit té? El sentit dels snapshots és poder fer còpies de seguretat o realitzar tasques de manteniment sense afectar el rendiment del sistema, ja que només es guarden les diferències respecte  les dades originals. Això permet estalviar espai i recursos en comparació amb altres mètodes de còpia de seguretat.

### Escenari: El LV original creix més que l'snapshot

Imagina que el volum lògic original `/dev/vg_webapp/lv_data` creix més en mida que l'snapshot `snap_data`. Si la mida de l'snapshot no és suficient per registrar totes les modificacions del volum lògic original, l'snapshot es corromprà.

1. Creeu un fitxer de 1GB en el directori `/opt/webapp/data`:

    ```bash
    dd if=/dev/zero of=/opt/webapp/data/file4 bs=1G count=1 oflag=dsync
    ```

    **Nota**: Recordeu que la mida de l'snapshot és de 1GB. El fitxer `file4` fa que el volum lògic original `/dev/vg_webapp/lv_data` creixi més en mida que l'snapshot `snap_data`.

2. Comproveu la situació amb la comanda `lvs`:

    ```bash
    [root@localhost ~]# lvs
    LV         VG        Attr       LSize  Pool Origin  Data%  Meta%  Move Log Cpy%Sync Convert
    root       almalinux -wi-ao---- 16.41g
    swap       almalinux -wi-ao----  2.00g
    lv_data    vg_webapp owi-aos--- 20.00g
    lv_run     vg_webapp -wi-a-----  1.00g
    lv_sources vg_webapp -wi-a-----  1.00g
    snap_data  vg_webapp swi-I-s---  1.00g      lv_data 100.00
    ```

    Fixeu-vos que l'snapshot `snap_data` està al 100% de la seva capacitat ja que no pot registrar més canvis del volum lògic original.

3. Comproveu que l'snapshot es desactiva amb la comanda `lvdisplay`:

    ```bash
    lvdisplay /dev/vg_webapp/snap_data 
    ```

    ```bash
    --- Logical volume ---
    LV Path                /dev/vg_webapp/snap_data
    LV Name                snap_data
    VG Name                vg_webapp
    LV UUID                UxIwLW-sppS-fxAt-ojqy-dWlx-0xhY-tu0CuR
    LV Write Access        read/write
    LV Creation host, time localhost.localdomain, 2024-07-16 10:21:33 +0200
    LV snapshot status     INACTIVE destination for lv_data
    LV Status              available
    # open                 0
    LV Size                20.00 GiB
    Current LE             5120
    COW-table size         1.00 GiB
    COW-table LE           256
    Snapshot chunk size    4.00 KiB
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:7
    ```

4. Feu servir la comanda `dmsetup` per obtenir una informació semblant:

    ```bash
    dmsetup status | grep snap_data
    ```

    Per fer-ho, podem filtrar la sortida amb la comanda `grep`. Recordeu que `dmsetup` és una eina que permet gestionar dispositius de dispositius de blocs, com ara els volums lògics de LVM.

    ```bash
    vg_webapp-snap_data: 0 41943040 snapshot Invalid
    vg_webapp-snap_data-cow: 0 2097152 linear
    ```

    En aquesta sortida, podem veure que l'snapshot `snap_data` ha canviat d'estat a `Invalid`. Això significa que l'snapshot ja no és vàlida i s'ha desactivat.

5. Finalment, podeu comprovar els missatges del sistema amb la comanda `grep`:

    ```bash
    grep Snapshot /var/log/messages
    ```

    WARNING: Snapshot vg_webapp-snap_data changed state to: Invalid and should be removed.

En totes les comandes anteriors, es pot veure que l'snapshot `snap_data` s'ha corromput i s'ha desactivat. Per tant, elimineu-la amb la comanda `lvremove`:

```bash
lvremove /dev/vg_webapp/snap_data
Do you really want to remove active logical volume vg_webapp/snap_data? [y/n]: y
```

Creu un nou snapshot amb mida suficient per registrar les dades del volum lògic original:

```bash
lvcreate -L 2G -s -n snap_data /dev/vg_webapp/lv_data
```


### Configuració dels snapshots

LVM ens permet configurar els snapshots perquè s'estenguin automàticament quan arribin a un determinat límit de capacitat. Per exemple, si un snapshot arriba al 70% de la seva capacitat, es pot estendre automàticament un 50% més per evitar que es corrompi. Això és útil per a sistemes on les dades canvien ràpidament i els snapshots poden quedar obsoletes ràpidament. Per fer-ho, cal modificar el fitxer de configuració de LVM `/etc/lvm/lvm.conf`.

1. Obriu el fitxer de configuració de LVM amb un editor de text:

    ```bash
    vi /etc/lvm/lvm.conf
    ```

    Utilizeu `\` per buscar la secció `snapshot_autoextend_threshold` i `snapshot_autoextend_percent` i afegiu-hi els valors següents:

    ```bash
    snapshot_autoextend_threshold = 70
    snapshot_autoextend_percent = 50
    ```

2. Després de fer els canvis, deseu i tanqueu l'editor de text.
3. Reinicieu el servei de LVM:

    ```bash
    systemctl restart lvm2-lvmpolld
    ```

4. Creeu un nou snapshot amb una mida petita:

    ```bash
    lvcreate -L 1G -s -n snap_data /dev/vg_webapp/lv_data
    ```

5. Afegiu un fitxer de 500MB al directori `/opt/webapp/data`:

    ```bash
    dd if=/dev/zero of=/opt/webapp/data/file5.txt bs=1M count=500 oflag=dsync
    ```

6. Comproveu l'estat de l'snapshot amb la comanda `lvs`:

    ```bash
    LV         VG        Attr       LSize  Pool Origin  Data%  Meta%  Move Log Cpy%Sync Convert
    root       almalinux -wi-ao---- 16.41g
    swap       almalinux -wi-ao----  2.00g
    lv_data    vg_webapp owi-aos--- 20.00g
    lv_run     vg_webapp -wi-a-----  1.00g
    lv_sources vg_webapp -wi-a-----  1.00g
    snap_data  vg_webapp swi-a-s---  1.00g      lv_data 50.10
    ```

7. Modifiqueu el fitxer  `/opt/webapp/data`:

    ```bash
    dd if=/dev/zero of=/opt/webapp/data/file5.txt bs=1M count=300 oflag=dsync
    ```

8. Comproveu l'estat de l'snapshot amb la comanda `lvs`:

    ```bash
    LV         VG        Attr       LSize  Pool Origin  Data%  Meta%  Move Log Cpy%Sync Convert
    root       almalinux -wi-ao---- 16.41g
    swap       almalinux -wi-ao----  2.00g
    lv_data    vg_webapp owi-aos--- 20.00g
    lv_run     vg_webapp -wi-a-----  1.00g
    lv_sources vg_webapp -wi-a-----  1.00g
    snap_data  vg_webapp swi-a-s---  1.00g      lv_data 64.12
    ```

    Com hem modificat el fitxer `file5.txt`, l'snapshot ha augmentat la seva capacitat al 64%.

9. Modifiqueu de nou el fitxer `/opt/webapp/data`:

    ```bash
    dd if=/dev/zero of=/opt/webapp/data/file5.txt bs=1M count=200 oflag=dsync
    ```

10. Comproveu l'estat de l'snapshot amb la comanda `lvs`:

    ```bash
    LV         VG        Attr       LSize  Pool Origin  Data%  Meta%  Move Log Cpy%Sync Convert
    root       almalinux -wi-ao---- 16.41g
    swap       almalinux -wi-ao----  2.00g
    lv_data    vg_webapp owi-aos--- 20.00g
    lv_run     vg_webapp -wi-a-----  1.00g
    lv_sources vg_webapp -wi-a-----  1.00g
    snap_data  vg_webapp swi-a-s---  1.00g      lv_data 72.41
    ```

    Fixeu-vos que l'snapshot `snap_data` ha arribat al 72% de la seva capacitat. Això hauria d'activar l'extensió automàtica de l'snapshot.

11. Torneu a comprobar l'estat amb `lvs`:

  ```bash
  LV         VG        Attr       LSize  Pool Origin  Data%  Meta%  Move Log Cpy%Sync Convert
  root       almalinux -wi-ao---- 16.41g
  swap       almalinux -wi-ao----  2.00g
  lv_data    vg_webapp owi-aos--- 20.00g
  lv_run     vg_webapp -wi-a-----  1.00g
  lv_sources vg_webapp -wi-a-----  1.00g
  snap_data  vg_webapp swi-a-s---  1.50g      lv_data 48.28
  ```

 De forma automàtica, l'snapshot s'ha ampliat un 50% més de la seva capacitat original. Això permet que l'snapshot s'adapti als canvi i redueixi la probabilitat de corrupció.

### Neteja

1. Elimineu els fitxers de prova:

    ```bash
    rm -rf /opt/webapp/data/*
    ```

2. Elimineu la carpeta `/snaps`:

    ```bash
    rm -rf /snaps
    ```

3. Elimineu l'snapshot:

    ```bash
    lvremove /dev/vg_webapp/snap_data
    ```

### Anàlisi de l'ús dels snapshots

En el context de la nostra webapp que utilitza LVM, necessitem realitzar un backup de la nostra carpeta de dades que triga aproximadament 1 hora. Durant aquesta hora, es creen o modifiquen aproximadament 1GB de dades. Quines consideracions hauríem de tenir en compte per establir una política eficient d'snapshots, tenint en compte factors com el temps, l’espai, la freqüència i la retenció?