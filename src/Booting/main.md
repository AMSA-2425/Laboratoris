# Booting

Quan arranquem un ordinador, tenen lloc una sèrie de processos que permeten que el sistema operatiu es carregui i es posi en marxa. Aquests processos són els que es coneixen com a arrancada del sistema.

1. **Càrrega del BIOS o UEFI**. Tots els ordinadors tenen un programa emmagatzemat en una memòria no volàtil que s'executa quan l'ordinador s'engega (**ROM**). Aquest programa s'anomena BIOS (Basic Input/Output System) o UEFI (Unified Extensible Firmware Interface). En els ordinadors més antics s'utilitza el BIOS, mentre que en els més moderns s'utilitza l'UEFI.

2. **Test de l'ordinador**. El BIOS o l'UEFI realitza un test de l'ordinador per assegurar-se que tots els components funcionen correctament. Aquest test s'anomena **POST** (Power-On Self Test). Si el test falla, l'ordinador emet una sèrie de senyals acústics o visuals per indicar quin component ha fallat.

3. **Selecció del dispositiu d'arrancada**. El BIOS o l'UEFI permet triar quin dispositiu volem utilitzar per a carregar el sistema operatiu. Aquest dispositiu pot ser el disc dur, un dispositiu USB, un CD-ROM, etc. Un cop triat el dispositiu d'arrancada, el BIOS o l'UEFI carrega el gestor d'arrancada segons estigui indicat en el **MBR** (Master Boot Record) situat en el 1er bloc de disc.

4. **Identificació de la partició d'arrancada**. El BIOS o l'UEFI identifica la partició d'arrancada del dispositiu d'arrancada. Aquesta partició conté el gestor d'arrancada i el kernel del sistema operatiu.

5. **Càrrega del gestor d'arrancada**. El BIOS o l'UEFI carrega el gestor d'arrancada. El gestor d'arrancada és un petit programa que permet triar quin sistema operatiu volem carregar. Els gestors d'arrancada més comuns són el **GRUB** (Grand Unified Bootloader) i el **LILO** (Linux Loader). Aquests gestors d'arrancada mostren una llista amb els sistemes operatius disponibles i permeten triar-ne un. Quan triem un sistema operatiu, el gestor d'arrancada carrega el kernel d'aquest sistema operatiu. Després carrega el sistema d'inicialització.

6. **Sistema d'inicialització**. El sistema d'inicialització és el primer procés que s'executa en un sistema operatiu. En el cas de GNU/Linux, el sistema d'inicialització més comú és el **systemd**. Una altre gestor d'arrancada, més vell però molt utilitzat és el **SysVInit (Init)**.  El sistema d'inicialització s'encarrega de carregar els serveis i els daemons del sistema operatiu.

7. **Execució dels scripts d'inicialització**. El sistema d'inicialització executa una sèrie d'scripts  que preparen el sistema per a la seva utilització. Aquests scripts configuren els dispositius de xarxa, carreguen els mòduls del kernel i preparen els serveis del sistema.

8. **Inici de la sessió d'usuari**. Finalment, el sistema d'inicialització carrega el gestor de finestres o la línia de comandes, i l'usuari pot iniciar la seva sessió.



