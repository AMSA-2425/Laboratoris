# Carregant un mòdul addicional

1. **Carrega el mòdul del nucli**: En aquest pas, carregarem un mòdul del nucli addicional a la initramfs actual. En aquest cas, carregarem el mòdul `nls_utf8`, que és un mòdul de suport per a la codificació de caràcters UTF-8. El primer pas és comprovar si el mòdul ja està carregat:

    ```bash
    lsmod | grep nls_utf8
    ```

    Si la comanda no retorna cap sortida, significa que el mòdul `nls_utf8` no està carregat actualment al sistema.

2. **Comprovar si el modul esta carregat a la initramfs**: Abans de carregar el mòdul a la initramfs, comprovem si ja està present:

    ```bash
    lsinitramfs /boot/initrd.img-$(uname -r) | grep nls_utf8
    ```

    Si la comanda no retorna cap sortida, significa que el mòdul `nls_utf8` no està present a la initramfs actual.

3. **Cerca la ubicació del mòdul del nucli**: Utilitza la comanda `modinfo` per cercar la ubicació del mòdul `nls_utf8`.

    ```bash
    modinfo nls_utf8
    ```

    Aquesta comanda mostrarà informació detallada sobre el mòdul `nls_utf8`, incloent la ubicació del fitxer del mòdul. En aquest cas, el fitxer del mòdul es troba a `/lib/modules/$(uname -r)/kernel/fs/nls/nls_utf8.ko`.

4. **Carrega el mòdul a la initramfs**: Utilitza la comanda `echo` per afegir el mòdul `nls_utf8` a la llista de mòduls que s'inclouran a la initramfs durant el procés de generació.

    ```bash
    echo nls_utf8 >> /etc/initramfs-tools/modules
    ```

5. **Regenera la initramfs**: Utilitza la comanda `update-initramfs` per regenerar la initramfs amb el mòdul `nls_utf8` inclòs.

    ```bash
    update-initramfs -u
    ```

    Aquesta comanda regenerarà la initramfs amb el mòdul `nls_utf8` inclòs. Si tot ha anat bé, no hauria de veure cap error durant el procés de generació.

6. **Reinicia el sistema**: Reinicia el sistema per aplicar els canvis.

    ```bash
    reboot
    ```

7. **Comprova si el mòdul s'ha carregat**: Després de reiniciar el sistema, comprova si el mòdul `nls_utf8` s'ha carregat correctament.

    ```bash
    lsmod | grep nls_utf8
    lsinitramfs /boot/initrd.img-$(uname -r) | grep nls_utf8
    ```

    Si la comanda `lsmod` retorna el mòdul `nls_utf8`, significa que el mòdul s'ha carregat correctament al sistema. Si la comanda `lsinitramfs` retorna el mòdul `nls_utf8`, significa que el mòdul s'ha inclòs correctament a la initramfs.
