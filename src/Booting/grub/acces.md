# Accés no autoritzat a través del GRUB

Assumeix que teniu un servidor instal·lat amb un carregar de sistema GRUB. Un atacant ha conseguit accés físic al vostre servidor i vol modificar la contrasenya de l'usuari root per a poder accedir al sistema amb privilegis d'administrador. Per a fer-ho, l'atacant ha reiniciat el sistema i ha accedit al carregador de sistema GRUB. A continuació assumirem el rol i veurem com podem accedir al sistema operatiu i modificar la contrasenya de l'usuari root a través del carregador de sistema GRUB.

1. Reinicia el sistema i accedeix al carregador de sistema GRUB.
2. Selecciona el sistema operatiu que vols arrancar i prem la tecla `e` per a editar les opcions de l'arrencada.

    ![Configuració de la entrada `debian` del GRUB](../figures/GRUB/root-password/grub-config.png)

3. Busca la línia que comença amb `linux` i acaba amb `ro` i afegeix-hi la següent opció: `init=/bin/bash`.

    ![Modificació de la línia `linux` del GRUB](../figures/GRUB/root-password/grub-config-mod.png)

    > **✏️ Nota**:
    >
    > La opció `ro` indica que el sistema s'ha de muntar en mode de només lectura. Això significa que no es poden modificar els fitxers del sistema. Afegint la opció `init=/bin/bash`, indiquem al sistema que ha d'iniciar el procés d'inicialització amb `/bin/bash` en lloc del sistema d'inicialització habitual. Això ens permetrà accedir al sistema amb un intèrpret de comandes `bash` sense haver d'iniciar el sistema completament.

4. Prem la tecla `Ctrl + X` per a iniciar el sistema amb les opcions modificades.
5. Un cop iniciat el sistema, hauries d'accedir a una consola `bash`.

   ![Consola `bash` iniciada des del GRUB](../figures/GRUB/root-password/bash.png)

6. Un cop aquí, montarem el sistema de fitxers en mode de lectura i escriptura amb la comanda següent:

    ```bash
    mount -o remount,rw /
    ```

7. Ara que el sistema esta muntat, accedirem al sistema amb una chroot per a poder modificar la contrasenya de l'usuari root. Per a fer-ho, executa la comanda següent:

    ```bash
    chroot /
    ```

    > ℹ️ **Què és una chroot?**
    >
    > Una chroot és un entorn aïllat que permet executar programes en un directori arrel diferent del directori arrel del sistema. Això ens permet accedir al sistema com si estiguéssim dins del directori arrel del sistema, però sense haver d'iniciar el sistema completament. Això és útil per a realitzar tasques de manteniment o recuperació del sistema sense haver d'iniciar el sistema completament.

8. Un cop dins de la chroot, modifica la contrasenya de l'usuari root amb la comanda `passwd`:

    ```bash
    passwd
    ```

9. Introdueix la nova contrasenya de l'usuari root i confirma-la.

10. Un cop modificada la contrasenya, surt de la chroot amb la comanda `exit`:

    ```bash
    exit
    ```

11. Reinicia el sistema amb la comanda `reboot`:

    ```bash
    reboot
    ```

12. Un cop reiniciat el sistema, accedeix amb l'usuari root i la nova contrasenya que has definit.

> **🔍 Pregunta**: *Com podriam protegir els nostres servidors d'aquestes situacions?*
>
> * La principal manera de protegir els servidors d'aquest tipus d'atacs és assegurar-se que només les persones autoritzades poden accedir físicament al servidor.
> * Configurar el GRUB perquè requereixi una contrasenya per a poder editar les opcions de l'arrencada és una bona pràctica. Això dificulta l'accés no autoritzat al sistema a través del GRUB.

---

> **👁️ Observació**:
>
> Malgrat l'ús d'una contrasenya per a protegir el GRUB, aquesta tècnica no és infal·lible. Un atacant amb accés físic pot montar un usb bootable i iniciar el sistema amb aquest dispositiu. Un cop iniciat el sistema, l'atacant podria montar el sistema de fitxers i modificar la contrasenya de l'usuari root. Ara bé, es podria configurar el BIOS o UEFI per a desactivar l'arrencada des de dispositius externs com els USBs. Això dificultaria l'accés no autoritzat al sistema a través d'aquesta tècnica.

---

> **🤔 Reflexió**:
> En les dues situacions, si el disc dur està xifrat, l'atacant no podrà utilitzar aquestes tècniques per a accedir al sistema.
