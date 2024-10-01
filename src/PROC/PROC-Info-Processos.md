## 7.1. Informació de Processos‏
- El directori /proc conté un subdirectori per cada procés que s'estigui executant en el sistema.

- Aquests subdirectoris s'identifiquen amb el pid del procés en execució. Per exemple, la infor-mació corresponden al procés init es localitza en el directori “/proc/1”.

- Cada un d'aquests subdirectoris contenen els pseudo-fitxers i directoris següents:

```md
| cmdline    | fd         | stat     |
| cwd        | maps       | statm    |
| cpu        | mem        | stat     |
| environ    | mounts     |          |
| exe        | root       |          |
``` 

### cmdline (fitxer)‏

- Conté la línia d'ordres completa de crida al procés (sempre que el procés no hagi estat suspès o que es tracti d'un procés zombi).

### cwd (enllaç simbòlic)‏

- Enllaç al directori de treball actual del procés. 

###  environ (fitxer)‏

- Conté l'entorn del procés. Les entrades estan separades per caràcters nuls. 

###  exe (enllaç simbòlic)‏

- Enllaç a el fitxer binari que va ser executat a l'arrencar aquest procés.

###  fd (directori)‏

- Subdirectori que conté una entrada per cada fitxer que té obert el procés. Cada entrada és un enllaç simbòlic a el fitxer real i utilitza com a nom el descriptor de l'arxiu.
	
	Exemple: 
```bash	
# ls -la /proc/2354/fd
lr-x------   1 Joan wheel  64 feb 24 09:35 0 -> /dev/null
l-wx------  1 Joan  wheel  64 feb 24 09:35 1 -> /home/Joan/.xsession-errors
l-wx------  1 Joan  wheel  64 feb 24 09:35 2 -> /home/Joan/.xsession-errors
lrwx------  1 Joan  wheel  64 feb 24 09:35 3 -> socket:[3634]
``` 

###  maps (fitxer)‏

- Conté les regions de memòria actualment associades amb el procés i els seus permisos d'accés.

- El format de l'arxiu és el següent :

```md
| Adreça            | Perms | Desplaça | Disp  | Nodo-i | Pathname           |
|-------------------|-------|----------|-------|--------|--------------------|
| 08048000-0804b000 | r-xp  | 00000000 | 03:06 | 784954 | /bin/sleep         |
| 0804b000-0804c000 | rw-p  | 00002000 | 03:06 | 784954 | /bin/sleep         |
| 0804c000-0804e000 | rwxp  | 00000000 | 00:00 | 0      |                    |
| 40000000-40011000 | r-xp  | 00000000 | 03:06 | 735844 | /lib/ld-2.2.5.so   |
| 40011000-40012000 | rw-p  | 00010000 | 03:06 | 735844 | /lib/ld-2.2.5.so   |
```

###  mem (fitxer)‏

- Permet l'accés a la memòria del procés.

###  root (enllaç simbòlic)‏

- Apunta a l'arrel de sistema de fitxers del procés.

###  stat (fitxer)‏

- Conté informació d'estat del procés.

- Entre altra informació conté: identificador del procés, nom, estat, PPID, distribució del temps d'execució (usuari/ sistema), quantum, prioritat, quan es va llançar el procés, mida de memòria del procés, valor actual del registre esp i eip, senyals pendents/bloquejades/ignorades/capturades, etc.

###  statm (fitxer)‏

- Aporta informació sobre la memòria del procés: mida total programa, mida conjunt resident, pàgines compartides, pàgines de codi, pàgines de dades/pila, pàgines de llibreria i pàgines modificades.

###  status (fitxer)‏

- Conté part de la informació dels fitxers stat i statm, però en un format més amigable per a l'usuari.
	Exemple:

```bash		
# more /proc/self/status
Name:   more
State:  R (running)‏
Pid:    13717
PPid:   13371
TracerPid:  0
Uid:    501     501     501     501
Gid:    501     501     501     501
FDSize: 32
Groups: 501 4 6 10 19 22 80 81 101 102 103 104 
VmSize: 1552 kB
VmLck:  0 kB
VmRSS:  512 kB
VmData: 44 kB
VmStk:  20 kB
VmExe:  24 kB
VmLib:  1196 kB
SigPnd: 0000000000000000
SigBlk: 0000000000000000
SigIgn: 8000000000000000
SigCgt: 0000000008080006
CapInh: 0000000000000000
CapPrm: 0000000000000000
CapEff: 0000000000000000
``` 