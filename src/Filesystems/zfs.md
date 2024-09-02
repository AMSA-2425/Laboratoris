# Explorant d'un sistema de fitxers avançat: zfs

1. Instal·la el repositori EPEL:

      ```sh
      dnf install epel-release -y
       ```

2. Afegeix el repositori ZFS:

      ```sh
      dnf install https://zfsonlinux.org/epel/zfs-release-2-3$(rpm --eval "%{dist}").noarch.rpm -y
      ```

3. Instal·lació dels paquets necessaris:

      ```sh
      dnf dnf install kernel-devel
      ```

4. Actualitzar el sistema:

      ```sh
      dnf update -y
      ```

5. Segons la documentació, veure [Getting Started](https://openzfs.github.io/openzfs-docs/Getting%20Started/RHEL-based%20distro/index.html): Per defecte, el paquet zfs-release està configurat per instal·lar paquets de tipus DKMS perquè funcionin amb una àmplia gamma de kernels. Per poder instal·lar els mòduls kABI-tracking, cal canviar el repositori predeterminat de zfs a zfs-kmod.

      ```sh
      dnf config-manager --disable zfs
      dnf config-manager --enable zfs-kmod
      dnf install zfs
      ```

6. Reinicieu la màquina virtual:

      ```sh
      reboot
      ```

7. Carregeu el modul zfs al kernel de linux:

      ```sh
      modprobe zfs
      ```

## Creació d'un pool ZFS

Una pool ZFS és un conjunt de dispositius de blocs que es poden utilitzar per emmagatzemar dades. Aquesta pool pot estar formada per un o més dispositius de blocs. Aquests dispositius poden ser discos durs, SSD, dispositius de xarxa, etc. Aquesta pool es pot utilitzar per crear conjunts de dades i sistemes de fitxers ZFS. Utiltizarem el disc **/etc/vdb** per crear la pool.

1. Creació de la pool:

      ```sh
      zpool create -f zfspool /dev/vdb
      ```

2. Comprovació de la pool:

      ```sh
      zpool status
      ```

      ```shell
      pool: zfspool
      state: ONLINE
      scan: none requested
      config:

      NAME        STATE     READ WRITE CKSUM
      zfspool     ONLINE       0     0     0
        vdb       ONLINE       0     0     0

      errors: No known data errors
      ```

3. Creació d'un sistema de fitxers que anomenarem (dades):

      ```sh
      zfs create zfspool/dades
      ```

4. Comprovació del conjunt de dades:

      ```sh
      zfs list
      ```

      ```shell
      NAME            USED  AVAIL     REFER  MOUNTPOINT
      zfspool         135K   352M     25.5K  /zfspool
      zfspool/dades    24K   352M       24K  /zfspool/dades
      ```

      **NOTA**: Ara mateix tenim muntats dos sistemes de fitxers: **zfspool** i **zfspool/dades**. Per defecte, els sistemes de fitxers ZFS es muntaran a */zfspool* i */zfspool/dades*. Però, podem canviar aquest comportament i muntar els sistemes de fitxers a un altre directori.

5. Anem a canviar el punt de muntatge de **zfspool/dades** a */mnt/dades*:

      ```sh
      mkdir /mnt/dades
      ```

      ```sh
      zfs set mountpoint=/mnt/dades zfspool/dades
      ```

      ```sh
      zfs list
      ```

      ```shell
      NAME            USED  AVAIL     REFER  MOUNTPOINT
      zfspool         135K   352M     25.5K  /zfspool
      zfspool/dades    24K   352M       24K  /mnt/dades
      ```

6. Ara crearem uns quants fitxers i directoris a **/mnt/data**:

      ```sh
      mkdir /mnt/dades/sergi
      mkdir /mnt/dades/adria
      touch /mnt/dades/sergi/a.txt
      touch /mnt/dades/sergi/a.c
      mkdir /mnt/dades/adria/config
      touch /mnt/dades/adria/config/.vim
      ```

7. ZFS ens permet crear snapshots (instantànies) dels nostres sistemes de fitxers. Aquestes instantànies són còpies de seguretat dels nostres sistemes de fitxers en un moment determinat. Aquestes instantànies es poden utilitzar per restaurar els nostres sistemes de fitxers en cas de fallada o error. Crearem una instantània del nostre sistema de fitxers **zfspool/dades**:

      ```sh
      zfs snapshot zfspool/dades@snap1
      ```

8. Ara eliminarem el directori **/mnt/dades/adria/config**:

      ```sh
      rm -rf /mnt/dades/adria/config
      ```

9. Podem utilitzar la comanda **zfs rollback** per restaurar el nostre sistema de fitxers a l'estat de l'instantània:

      ```sh
      zfs rollback zfspool/dades@snap1
      ```

10. Comprovem que el directori **/mnt/dades/adria/config** ha estat restaurat:

      ```sh
      ls -la /mnt/dades/adria/config
      ```

      ```shell
      total 2
      drwxr-xr-x. 2 root root 3 Oct  3 10:01 .
      drwxr-xr-x. 3 root root 3 Oct  3 10:01 ..
      -rw-r--r--. 1 root root 0 Oct  3 10:01 .vim
      ```

11. Podem utilitzar la comanda **zfs clone** per crear un clon del nostre sistema de fitxers **zfspool/dades**:

      ```sh
      zfs clone zfspool/dades@snap1 zfspool/dades/clone1
      ```

      **OBSERVACIÓ 1**: Els clons en ZFS permeten realitzar migracions de dades eficients i segures. Abans d'efectuar canvis en el sistema de producció o transferir dades a un nou sistema, es pot crear un clon de les dades existents per provar la migració sense afectar les dades originals

      **OBSERVACIÓ 2**: Quan es requereix realitzar operacions de processament, anàlisi o transformació de dades, els clons permeten fer-ho sense modificar o posar en perill les dades originals.

      ```sh
      zfs list
      ```

      ```shell
      NAME                   USED  AVAIL     REFER  MOUNTPOINT
      zfspool                217K   352M       24K  /zfspool
      zfspool/dades           43K   352M       29K  /mnt/dades
      zfspool/dades/clone1     0B   352M       29K  /mnt/dades/clone1
      ```

12. Per eliminar un clon, utilitzarem la comanda **zfs destroy**:

      ```sh
      zfs destroy zfspool/dades/clone1
      ```

13. Per eliminar una instantània, utilitzarem la comanda **zfs destroy**:

      ```sh
      zfs destroy zfspool/dades@snap1
      ```

14. Per eliminar un sistema de fitxers, utilitzarem la comanda **zfs destroy**:

      ```sh
      zfs destroy zfspool/dades
      ```

      > **NOTA**: Si enlloc d'eliminar volem únicament desmuntar, utilitzarem la comanda **zfs umount**. Per exemple: ```zfs umount zfspool/dades```.

15. Per eliminar una pool, utilitzarem la comanda **zpool destroy**:

      ```sh
      zpool destroy zfspool
      ```

