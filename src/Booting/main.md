# Arrancada del sistema

Quan arranquem un ordinador, tenen lloc una sèrie de processos que permeten que el sistema operatiu es carregui i es posi en marxa. Aquests processos són els que es coneixen com a arrancada del sistema.

1. **Càrrega del BIOS o UEFI**. Tots els ordinadors tenen un programa emmagatzemat en una memòria no volàtil que s'executa quan l'ordinador s'engega (NVRAM). Aquest programa s'anomena BIOS (Basic Input/Output System) o UEFI (Unified Extensible Firmware Interface). En els ordinadors més antics s'utilitza el BIOS, mentre que en els més moderns s'utilitza l'UEFI.

2. **Test de l'ordinador**. El BIOS o l'UEFI realitza un test de l'ordinador per assegurar-se que tots els components funcionen correctament. Aquest test s'anomena POST (Power-On Self Test). Si el test falla, l'ordinador emet una sèrie de senyals acústics o visuals per indicar quin component ha fallat.

3. **Selecció del dispositiu d'arrancada**. El BIOS o l'UEFI permet triar quin dispositiu volem utilitzar per a carregar el sistema operatiu. Aquest dispositiu pot ser el disc dur, un dispositiu USB, un CD-ROM, etc. Un cop triat el dispositiu d'arrancada, el BIOS o l'UEFI carrega el gestor d'arrancada.

4. **Identificació de la partició d'arrancada**. El BIOS o l'UEFI identifica la partició d'arrancada del dispositiu d'arrancada. Aquesta partició conté el gestor d'arrancada i el kernel del sistema operatiu.

5. **Càrrega del gestor d'arrancada**. El BIOS o l'UEFI carrega el gestor d'arrancada. El gestor d'arrancada és un petit programa que permet triar quin sistema operatiu volem carregar. Els gestors d'arrancada més comuns són el GRUB (Grand Unified Bootloader) i el LILO (Linux Loader). Aquests gestors d'arrancada mostren una llista amb els sistemes operatius disponibles i permeten triar-ne un. Un cop triat, carreguen el carregador de sistema.

6. **Selecció del kernel**. El kernel és el nucli del sistema operatiu. Quan triem un sistema operatiu, el gestor d'arrancada carrega el kernel d'aquest sistema operatiu. El kernel és el programa que es carrega en primer lloc i que es comunica directament amb el maquinari de l'ordinador.

7. **Carregador de sistema**. El carregador de sistema és un petit programa que carrega el nucli del sistema operatiu. En el cas de GNU/Linux, el carregador de sistema més comú és el systemd-boot. Aquest carregador carrega el nucli del sistema operatiu i el sistema d'inicialització.

8. **Sistema d'inicialització**. El sistema d'inicialització és el primer procés que s'executa en un sistema operatiu. En el cas de GNU/Linux, el sistema d'inicialització més comú és el systemd. Aquest sistema d'inicialització s'encarrega de carregar els serveis i els daemons del sistema operatiu.

9. **Execució dels scripts d'inicialització**. Un cop carregat el sistema d'inicialització, aquest executa una sèrie de scripts d'inicialització que preparen el sistema per a la seva utilització. Aquests scripts configuren els dispositius de xarxa, carreguen els mòduls del kernel i preparen els serveis del sistema.

10. **Inici de la sessió d'usuari**. Finalment, el sistema d'inicialització carrega el gestor de finestres o la línia de comandes, i l'usuari pot iniciar la seva sessió.

En aquest laboratori veurem totes aquestes fases en una màquina virtual i modificarem els parametres per veure com afecten als sistemes.

## Objectius

- Entendre com funciona el procés d'arrancada del sistema.
- Conèixer els diferents components implicats en l'arrancada del sistema.
- Apendre a gestionar i optimitzar el procés d'arrancada.

## Continguts

1. [UEFI i dispositius d'arrancada](./uefi.md)
2. [GRUB](./grub.md)
3. [initramfs](./initramfs.md)
4. [Inici del sistema i Dimonis de gestió de serveis](./systemd.md)

## Activitats

**Realització de les tasques**: 50%

S'ha de mostrar en un document amb format lliure les evidències de la realització de les tasques. Aquest document es pot incloure al informe tècnic o es pot lliurar com a document adjunt. En aquest document heu de mostrar les dificultats trobades i com les heu resolt. Us recomano que feu servir eines de captura de pantalla per a mostrar les evidències. Per exemple, podeu incloure una secció anomenada **Troubleshooting** on mostreu les dificultats trobades i com les heu resolt.

**Informe tècnic**: 50%

El informe tècnic ha de contenir respostes a les preguntes plantejades a continuació:

1. **Investigació d'una unitat del sistema**
   - Elegeix una unitat del sistema, com ara `ssh.service`, i investiga la seva funció i configuració.
   - Utilitza les comandes `systemctl status` i `systemctl cat` per obtenir més informació sobre la unitat.
   - Inclou a l'informe  els resultats de la teva investigació:
     - Descripció de la unitat.
     - Documentació associada.
     - Dependències i condicions.
     - Tipus de servei i comandaments d'inici i parada.
     - Temps d'execució i estat actual.

2. **Comparació entre arrencada amb i sense interfície gràfica**
   - Instal·la la interfície gràfica utilitzant la comanda `tasksel` i selecciona l'opció `Debian desktop environment`.
   - Compara el temps d'arrencada del sistema amb i sense interfície gràfica utilitzant la comanda `systemd-analyze`.
   - Inclou al informe de la diferència entre arrencar el sistema amb una interfície gràfica i sense interfície gràfica, incloent:
     - Temps d'arrencada del kernel i l'espai d'usuari.
     - Unitats crítiques i temps d'arrencada.
     - Avantatges i desavantatges de cada configuració

3. **Dissenyeu un escenari real on un script d'arrancada podria ser útil**
   - Pensa en un escenari real on un script d'arrancada podria ser útil per configurar l'entorn de l'usuari.
   - Crea un script d'arrancada que realitzi una tasca específica en aquest escenari.
   - Configura el script d'arrancada perquè s'executi automàticament quan un usuari inicia una sessió de terminal.
   - Inclou a l'informe amb els detalls de l'escenari i el script d'arrancada, incloent:
     - Descripció de l'escenari i la tasca a realitzar.
     - Contingut del script d'arrancada.
     - Configuració del script d'arrancada per a l'usuari.

## Rúbriques d'avaluació

| Criteris d'avaluació      | Excel·lent (5) | Notable(3-4) | Acceptable(1-2)  | No Acceptable (0) |
|---------------------------|----------------|--------------|------------------|-------------------|
| Contingut                 | El contingut és molt complet i detallat. S'han cobert tots els aspectes de la tasca. | El contingut és complet i detallat. S'han cobert la majoria dels aspectes de la tasca. | El contingut és incomplet o poc detallat. Falten alguns aspectes de la tasca. | El contingut és molt incomplet o inexistent.|
| Precisió i exactitud       | La informació és precisa i exacta. No hi ha errors. | La informació és precisa i exacta. Hi ha pocs errors. | La informació és imprecisa o inexacta. Hi ha errors. | La informació és molt imprecisa o inexacta. Hi ha molts errors. |
| Organització              | La informació està ben organitzada i estructurada. És fàcil de seguir. | La informació està organitzada i estructurada. És fàcil de seguir. | La informació està poc organitzada o estructurada. És difícil de seguir. | La informació està molt poc organitzada o estructurada. És molt difícil de seguir. |
| Diagrames i il·lustracions | S'han utilitzat diagrames i il·lustracions de collita pròpia per aclarir la informació. Són molt útils. | S'han utilitzat diagrames i il·lustracions de collita pròpia per aclarir la informació. Són útils. | S'han utilitzat pocs diagrames o il·lustracions de collita pròpia. Són poc útils. | No s'han utilitzat diagrames o il·lustracions de collita pròpia.|
| Plagi                     | No hi ha evidències de plagi. Tota la informació és original. | Hi ha poques evidències de plagi. La majoria de la informació és original. | Hi ha evidències de plagi. Alguna informació no és original. | Hi ha moltes evidències de plagi. Poca informació és original. |
| Bibliografia              | S'ha inclòs una bibliografia completa i detallada. | S'ha inclòs una bibliografia completa. | S'ha inclòs una bibliografia incompleta. | No s'ha inclòs una bibliografia. |
| Estil                     | L'estil és molt adequat i professional. S'ha utilitzat un llenguatge tècnic precís. | L'estil és adequat i professional. S'ha utilitzat un llenguatge tècnic precís. | L'estil és poc adequat o professional. Hi ha errors en el llenguatge tècnic. | L'estil és molt poc adequat o professional. Hi ha molts errors en el llenguatge tècnic. |

