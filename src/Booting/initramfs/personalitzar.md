# Personalitzar la initramfs

En aquesta secció, personalitzarem la initramfs afegint un missatge personalitzat que es mostrarà durant el procés d'inici. Això ens permetrà veure com podem modificar la initramfs per incloure scripts i binaris addicionals que es poden executar durant l'arrencada del sistema.

1. **Crea un nou directori per construir la initramfs personalitzada**:

    ```bash
    mkdir /tmp/initramfs
    cd /tmp/initramfs
    ```

    Això crea un espai de treball temporal on es construirà la nova imatge de la initramfs.

2. **Extreu la imatge actual de la initramfs**:

    ```bash
    unmkinitramfs /boot/initrd.img-$(uname -r) .
    ```

    > ℹ️ **Nota**:
    >
    > `unmkinitramfs` és una eina que permet descomprimir la imatge de la initramfs a un directori de treball. Això permet modificar els fitxers continguts en la initramfs.

3. **Crea un nou fitxer de script amb un missatge personalitzat**:

    ```bash
    echo 'echo "Hola, Initramfs!"' > scripts/init-top/custom_message.sh
    chmod +x scripts/init-top/custom_message.sh
    ```

4. **Actualitza el manifest de la initramfs**:

    ```bash
    echo 'scripts/init-top/custom_message.sh' >> scripts/init-top/order
    ```

    Això afegeix el nou script al manifest de la initramfs, assegurant-se que s'executi durant el procés d'inici.

5. **Crea una nova imatge de la initramfs amb el script personalitzat**:

    ```bash
    find . | cpio -o -H newc | gzip > /boot/initrd.img-$(uname -r)-custom
    ```

    > ℹ️ **Nota**:
    >
    > Aquest pas utilitza `cpio` per empaquetar tots els fitxers del directori de treball en un sol arxiu, i `gzip` per comprimir-lo. La nova imatge es guarda a `/boot` amb un nom personalitzat.

6. **Actualitza la configuració de GRUB per utilitzar la nova imatge de la initramfs**:

    ```bash
    update-initramfs -u -k $(uname -r)
    update-grub
    ```

7. **Reinicia el sistema**: Reinicia el sistema per aplicar els canvis.

    ```bash
    reboot
    ```

8. **Comprova el missatge personalitzat durant l'arrencada**: Després de reiniciar el sistema, observa el missatge personalitzat que s'ha afegit a la initramfs durant el procés d'inici.
