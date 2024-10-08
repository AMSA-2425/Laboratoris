
# Pràctica 1
## Installing OS

- [Instal·lació d'una màquina virtual](./Install/main.md)
  - [Instal·lació d'una màquina virtual amb Debian 12.5](./Install/debian.md)
  - [Hostname](./Install/hostname.md)
  - [Hosts](./Install/hosts.md)
  - [SSH i SFTP](./Install/ssh-sftp.md)

## Booting
- [Booting](./Booting/main.md)

## UEFI
- [UEFI](./Booting/uefi.md)
   - [Inciant la consola UEFI](./Booting/uefi/inciant.md)
   - [Observant els Dispositius Disponibles](./Booting/uefi/observant.md)

 ## Gestors d'arrancada
- [Gestors d'arrancada](./Booting/GestorsArrancada.md)
   - [LILO](./Booting/lilo.md)
   - [GRUB](./Booting/grub/modificacio.md) 
      - [Canvi del password de root a través del GRUB](./Booting/grub/acces.md)
      - [Actualitzant el GRUB](./Booting/grub/actualitzant.md)

 ## Inici del sistema 
 - [Sistema d'inicialització](./Booting/IniciServeis.md)
    - [SysVInit (Init)](./Booting/Init.md)
    - [Systemd](./Booting/systemd/analitzant.md)
       - [Creant i Gestionant serveis](./Booting/systemd/servei.md)
       - [Serveis programats](./Booting/systemd/programats.md)
       - [Anàlisi de logs](./Booting/systemd/logs.md)
       - [journalctl versus dmesg](./Booting/systemd/journalctl-dmesg.md)    
       - [Afegint informació d'inici](./Booting/systemd/inici.md)
       
 ## initramfs 
 - [initramfs](./Booting/initramfs.md)
    - [Examinant la initramfs](./Booting/initramfs/examinant.md)
    - [Carregant un mòdul addicional](./Booting/initramfs/carregant.md)
    - [Personalitzar la initramfs](./Booting/initramfs/personalitzar.md)
    
 
  ## PROC
 - [PROC](./PROC/PROC.md)
 	- [Informadió de Procesos](./PROC/PROC-Info-Processos.md)
 	- [Informadió del Sistema](./PROC/PROC-Info-Sistema.md)
    
 ## Tractament de Fitxers
 - [Tractament de fitxers](./TF.md)
 	- [SED](./SED/sed.md)
	- [AWK](./AWK/awk.md)
		- [Awk - Bàsic](./AWK/awk-basic.md)
		- [Awk - Intermedi](./AWK/awk-intermediate.md)
		- [Awk - Altres Exemples](./AWK/awk-altres-exemples.md)
	- [Expressions Regulars](./ExpressionsRegulars/ExpressionsRegulars.md)

  ## Xarxa
 - [Configuració de la Xarxa](./Xarxa.md)
    
 ## Kernel de Linux
- [Kernel de Linux](./Kernel/main.md)
  - [Analitzant les crides a sistema](./Kernel/syscalls.md)
  - [Espiant el Kernel](./Kernel/kernel-spy.md)
  - [Programació de mòduls](./kernel/modules.md)
  - [Compilant el Kernel](./Kernel/kernel.md)
  - [Crides a sistema personalitzades](./Kernel/add-syscalls.md)
  - [Rootkit: Escalada de Privilegis](./Kernel/rootkit.md)
  