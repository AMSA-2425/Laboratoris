# UEFI i dispositius d'arrancada

El *Unified Extensible Firmware Interface* (UEFI) és un estàndard de firmware dissenyat per reemplaçar els dissenys antics anomenats BIOS. Els principals problemes de les BIOS eren la falta d'estandardització.

> **ℹ️ UEFI o EFI?**
>
> La UEFI i la EFI són pràcticament el mateix. La EFI va ser el primer estàndard, però amb el temps va evolucionar cap a la UEFI actual.

En aquest laboratori, analitzarem el funcionament de la UEFI i com podem utilitzar-la.

## Objectius

- Conèixer el funcionament de la UEFI.
- Impacte de la UEFI en l'arrancada del sistema.
- Apendre les funcions bàsiques de la consola UEFI.
- Configurar la UEFI per a diferents finalitats.

## Preparació

1. Inicieu una màquina virtual amb el sistema operatiu AlmaLinux anomenada `VM1`. Podeu utilitzar la configuració per defecte.

2. Inicieu una altra màquina virtual amb el sistema operatiu Debian anomenada `VM2`. Podeu utilitzar també la configuració per defecte.

3. Afegiu a la màquina virtual `VM1` el disc virtual de la màquina virtual `VM2` o viceversa. Per fer-ho amb VMWare:

   - Apagueu la màquina virtual.
   - Aneu a la configuració de la màquina virtual.
   - Aneu a *Add*.
   - Selecciona *Hard Disk*.
   - Selecciona *Use an existing disk*.
   - Selecciona el disc virtual de la màquina virtual que vulgueu afegir.
   - Inicieu la màquina virtual.

    Un cop iniciada la màquina virtual, no hauríeu de detectar cap canvi. No obstant això, si inicieu sessió a la màquina virtual, podreu veure el disc afegit utilitzant la comanda `lsblk`.

    ```bash
    [root@localhost ~]# lsblk
    NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
    sr0                 11:0    1  1.7G  0 rom
    nvme0n1            259:0    0   20G  0 disk
    ├─nvme0n1p1        259:1    0  600M  0 part /boot/efi
    ├─nvme0n1p2        259:2    0    1G  0 part /boot
    └─nvme0n1p3        259:3    0 18.4G  0 part
    ├─almalinux-root 253:0    0 16.4G  0 lvm  /
    └─almalinux-swap 253:1    0    2G  0 lvm  [SWAP]
    nvme0n2            259:4    0   20G  0 disk
    ├─nvme0n2p1        259:5    0  512M  0 part
    ├─nvme0n2p2        259:6    0 18.5G  0 part
    └─nvme0n2p3        259:7    0  976M  0 part
    ```

    On `nvme0n2` és el disc afegit que conté la instal·lació de Debian i `nvme0n1` és el disc original que conté la instal·lació d'AlmaLinux.

## Tasques

1. [Inciant la consola UEFI](./uefi/inciant.md)
2. [Observant els Dispositius Disponibles](./uefi/observant.md)
3. [Navegant per la Consola UEFI](./uefi/navegant.md)
4. [Arrancant des d'una Partició EFI](./uefi/arrancant.md)
5. [Automatitzant l'Arrancada](./uefi/automatitzant.md)
6. [Creant una Entrada d’Arrancada Personalitzada](./uefi/entrada_personalitzada.md)
