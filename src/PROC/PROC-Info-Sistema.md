## 7.2. Informació del Sistema 

- La resta de fitxers del directori /proc proporcionen informació sobre el nucli i l'estat del sistema que s'està executant.

- Depenent de la configuració del nucli i dels mòduls carregats en el sistema, alguns dels fitxers enumerats a continuació poden no estar presents:

```md
| cmdline      | loadavg     | stat    |
| cpuinfo      | meminfo     | sys     |
| devices      | modules     | version |
| filesystems  | mounts      |         |
| interrupts   | net         |         |
| kcore        | partitions  |         |
| ksyms        | pci         |         |
``` 

###  cmdline (fitxer)‏

- Conté els paràmetres passats al nucli durant la seva arrencada. 	

###  cpuinfo (fitxer)‏

- Conté informació sobre el processador de sistema (tipus de processador, freqüència de rellotge, mida memòria cache, potència en bogomips, ...). La informació mostrada pot variar d'un processador a un altre.

Exemple: 
```bash		
# cat /proc/cpuinfo
processor  	: 0
Bogomips 	: 48.00
vendor_id    	: GenuineIntel
cpu family      : 6
model       	: 42
model name   	: Intel® Core(TM) i7-2620M CPU @ 2.70GHz
CPU Mhz  	: 2693.860
cache size   	: 4096 KB
fpu 		:  yes
Address sizes	: 36 bits physical, 48 bits virtual

processor  	: 1
Bogomips 	: 48.00
vendor_id    	: GenuineIntel
cpu family      : 6
model       	: 42
model name   	: Intel® Core(TM) i7-2620M CPU @ 2.70GHz
CPU Mhz  	: 2693.860
cache size   	: 4096 KB
fpu 		:  yes
Address sizes	: 36 bits physical, 48 bits virtual
``` 

### devices (fitxer)‏

- Mostra els dispositius actualment configurats en el sistema, classificats en dispositius de caràcters i de blocs. 

###   filesystems (fitxer)‏

- Conté informació sobre els sistemes de fitxers suportats pel sistema operatiu.

###   interrupts (fitxer)‏

- Mostra informació de les interrupcions per a cada IRQ d’una arquitectura x86 (IRQ, nombre d'interrupcions, tipus de interrupció i nom de dispositiu associat). 

###  kcore (fitxer)‏

- Representa la memòria física del sistema, en format simi-lar als fitxers core. 

###  ksyms (fitxer)‏

- Taula de definició dels símbols del nucli. Aquestes defini-cions són utilitzades per enllaçar mòduls.

###  loadavg (fitxer)‏

- Mostra la càrrega mitjana del processador (nombre mitjà de treballs a la cua d'execució en els darrers 1, 5 i 15 minuts, processos en execució/total i últim procés executat). 
	Exemple: 
```bash		
# cat /proc/loadavg	
2.10 1.98 1.95 3/87 14020
``` 

###   meminfo (fitxer)‏

- Conté informació sobre la quantitat de memòria lliure i usada en el sistema (tant física com d'intercanvi) així com de la memòria compartida i els buffers utilitzats pel nucli.

	Exemple: 
```bash	
# more /proc/meminfo
MemTotal:      4044348 kB
MemFree:       2036068 kB   Real free Memory
MemAvailable: 3130212 kB  Estimation of available Memory for 
                              starting new applications
-------------------------
Mlocked:        32 kB
SwapTotal:    978540 kB
SwapFree:     978540 kB
``` 

###  stat (fitxer)‏
- Conté informació sobre (entre d'altra):
	- cpu: temps d’usuari, baixa prioritat (nice), sistema, idle, espera de I/O, servint interrupcions h/w, servint interrupcions s/w, etc.
	- ctxt: número de canvis de context
	- btime: temps des de l'inici del sistema. Es pot convertir aquest temps en algo més comprensible amb la comanda:
		```bash	
		# date -d @
		``` 
	- processes: # de forks
	- procs_running: processos executant

	Exemple: 
```bash	
# more /proc/stat
cpu  8736 7931 3293 238176 2157 0 714 0 0 0
cpu0 4326 2331 1073 008176 1037 0 101 0 0 0
cpu1 4410 5600 2220 230000 1120 0 613 0 0 0
ctxt 1692161
btime 1727795318  
processes 18451
procs_running 3
``` 

###  modules (fitxer)‏

- Conté un llistat dels mòduls carregats en el sistema, especificant el nom del mòdul, la mida en memòria, si està actualment carregat (1) o no, i l'estat del mòdul.

###  net (directori)‏

- Conté informació referent a diversos paràmetres i estadístiques de la xarxa.

###   mounts (fitxer)‏

- Mostra informació relativa a tots els sistemes de fitxers muntats en el sistema.

###   partitions (fitxer)‏

-  Mostra les particions existents (dispositiu major i menor, nombre de blocs i el seu nom).

###  pci (fitxer)‏

- Conté la llista de tots els dispositius PCI trobats durant la inicialització del nucli i les seves configuracions respect-tives.

###   sys (directori)‏

- Directori que conté variables del nucli. Aquests paràmetres es poden llegir/modificar mitjançant sysctl.

###   version (fitxer)‏

- Aquesta cadena identifica la versió del nucli i de la distribució de Linux que s'està executant actualment. 






