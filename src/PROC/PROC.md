# PROC

/PROC: Pseudo-fitxers d'informació de processos

## Què és /PROC?

- El directori /proc és un pseudo-sistema de fitxers que actua d'interfície amb les estructures de dades internes del nucli.

- La major part d'aquest sistema de fitxers s'utilitza per obtenir informació sobre el sistema (accés només-lectura), però alguns fitxers permeten canviar certs paràmetres del nucli en temps d'execució.

- El sistema consta de dos grans grups d'infor-mació:
	- Informació dels processos en execució.
	- Informació del sistema.


## Informació de Processos‏
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
	> ls -la /proc/2354/fd
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
	 > more /proc/self/status
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

## Informació del Sistema 

- La resta de fitxers del directori /proc pro-porcionen informació sobre el nucli i l'estat del sistema que s'està executant.

-Depenent de la configuració del nucli i dels mòduls carregats en el sistema, alguns dels fitxers enumerats a continuació poden no estar presents:

```md
| cmdline      | loadavg     | stat     |
| cpuinfo      | meminfo     | sys    |
| devices      | modules     | version     |
| filesystems  | mounts     |          |
| interrupts   | net        |            |
| kcore        | partitions   |          |
| ksyms        | pci        |          |
``` 

## cmdline (fitxer)‏

- Conté els paràmetres passats al nucli durant la seva arrencada. 	

## cpuinfo (fitxer)‏

- Conté informació sobre el processador de sistema (tipus de processador, freqüència de rellotge, mida memòria cache, potència en bogomips, ...). La informació mostrada pot variar d'un processador a un altre.

Exemple: 
```bash		
	 > cat /proc/cpuinfo
processor  	: 0
vendor_id    	: GenuineIntel
cpu family      : 6
model       	: 42
model name   	: Intel® Core(TM) i7-2620M CPU @ 2.70GHz
CPU Mhz  	: 2693.860
cache size   	: 4096 KB
core id  	: 0
cpu cores 	: 1
fpu 	: 	yes

--------------------------------------------------

flags  	  : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm

Bogomips : 5387.72

Address sizes: 36 bits physical, 48 bits virtual	
``` 

## devices (fitxer)‏

- Mostra els dispositius actualment configurats en el sistema, classificats en dispositius de caràcters i de blocs. 

##  filesystems (fitxer)‏

- Conté informació sobre els sistemes de fitxers suportats pel sistema operatiu.

##  interrupts (fitxer)‏

- Mostra informació de les interrupcions per a cada IRQ d’una arquitectura x86 (IRQ, nombre d'interrupcions, tipus de interrupció i nom de dispositiu associat). 

##  kcore (fitxer)‏

- Representa la memòria física del sistema, en format simi-lar als fitxers core. 

##  ksyms (fitxer)‏

- Taula de definició dels símbols del nucli. Aquestes defini-cions són utilitzades per enllaçar mòduls.

##  loadavg (fitxer)‏

- Mostra la càrrega mitjana del processador (nombre mitjà de treballs a la cua d'execució en els darrers 1, 5 i 15 minuts, processos en execució/total i últim procés executat). 
	Exemple: 
```bash		
	 > cat /proc/loadavg	
	2.10 1.98 1.95 3/87 14020
``` 

##  meminfo (fitxer)‏

- Conté informació sobre la quantitat de memòria lliure i usada en el sistema (tant física com d'intercanvi) així com de la memòria compartida i els buffers utilitzats pel nucli.

	Exemple: 
```bash	
> more /proc/meminfo
MemTotal:      4044348 kB
MemFree:       2036068 kB   Real free Memory
MemAvailable: 3130212 kB  Estimation of available Memory for 
                              starting new applications
-------------------------
Mlocked:        32 kB
SwapTotal:    978540 kB
SwapFree:     978540 kB
``` 

##  stat (fitxer)‏
- Conté informació sobre (entre d'altra):
	- cpu: temps d’usuari, baixa prioritat (nice), sistema, idle, espera de I/O, servint interrupcions h/w, servint interrupcions s/w, etc.
	- ctxt: número de canvis de context
	- processes: # de forks
	- procs_running: processos executant

	Exemple: 
```bash	
> more /proc/stat
cpu  8736 7931 3293 238176 2157 0 714 0 0 0
cpu0 8736 7931 3293 238176 2157 0 714 0 0 0
ctxt 1692161
processes 18451
procs_running 3
``` 

##  modules (fitxer)‏

- Conté un llistat dels mòduls carregats en el sistema, especificant el nom del mòdul, la mida en memòria, si està actualment carregat (1) o no, i l'estat del mòdul.

##  net (directori)‏

- Conté informació referent a diversos paràmetres i estadístiques de la xarxa.

##  mounts (fitxer)‏

- Mostra informació relativa a tots els sistemes de fitxers muntats en el sistema.

##  partitions (fitxer)‏

-  Mostra les particions existents (dispositiu major i menor, nombre de blocs i el seu nom).

##  pci (fitxer)‏

- Conté la llista de tots els dispositius PCI trobats durant la inicialització del nucli i les seves configuracions respect-tives.

##  sys (directori)‏

- Directori que conté variables del nucli. Aquests paràmetres es poden llegir/modificar mitjançant sysctl.

##  version (fitxer)‏

- Aquesta cadena identifica la versió del nucli i de la distribució de Linux que s'està executant actualment. 





