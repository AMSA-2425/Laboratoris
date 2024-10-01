# Arrancant des d'una Partició EFI

Per arrancar la màquina virtual `VM1` amb el disc NVMe2 seleccionat com a dispositiu d'arrancada (això carregarà el sistema operatiu Debian), seguiu aquests passos:

1. Navegueu a la partició ESP del disc NVMe2.

    ```bash
    Shell> fs2:
    ```

2. Navegueu al directori `EFI` i seleccioneu el directori del sistema operatiu Debian.

    ```bash
    FS2:\> cd EFI
    FS2:\EFI> cd debian
    ```

3. Llisteu el contingut del directori per veure els fitxers d'arrancada.

    En aquest directori, podeu observar diferents fitxers que acaben amb `.efi`. Aquests fitxers són els fitxers d'arrancada del sistema operatiu Debian. El nom ens indica el tipus de firmware que utilitzen. Per exemple, `grubaa64.efi` és el fitxer d'arrancada del gestor d'arrancada GRUB per a sistemes de 64 bits.

    > **ℹ️ Quina és la diferència entre shimx64.efi, grubx64.efi, fbx64, mmx64?**
    >
    > Les principals diferències entre aquests fitxers són el tipus de firmware que utilitzen i la seva funció. El fitxer `shimx64.efi` és un fitxer d'arrancada segur que permet carregar altres fitxers d'arrancada segurs. El fitxer `grubx64.efi` és el fitxer d'arrancada del gestor d'arrancada GRUB. Els fitxers `fbx64.efi` i `mmx64.efi` no són específics de cap sistema operatiu, sinó que són part del firmware UEFI i proporcionen funcionalitats addicionals.

4. Seleccioneu el fitxer d'arrancada del grub per a arrancar el sistema operatiu Debian.

    ```bash
    FS2:\EFI\debian> grubaa64.efi
    ```

Això carregarà el gestor d'arrancada GRUB i us permetrà seleccionar el sistema operatiu Debian per a l'arrancada.
