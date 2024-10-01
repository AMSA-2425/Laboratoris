# SysVInit (Init)

## Passos en l'arrencada del sistema

Pas 1:  Arranc del Nucli. La seva imatge sol ser /boot/vmlinuz. Per assegurar-vos-en editeu el fitxer /etc/lilo.conf (si el modifiqueu heu d'executar # lilo). 

Pas 2: Execució del procés init (procés amb pid=1). Passos: 

	1. Execució dels scripts situats en /etc/rcS.d/ 

	2. Execució dels scripts situats en /etc/rcx.d/ 

- La x depèn del nivell d'execució (runlevel) del procés init. Nivells: (0: halt; 1: single; 2,3,4,5: nivells d'execució normals; 6: reboot). 

- Els scripts situats tant en /etc/rcS.d/ com en /etc/rcx.d/ són enllaços simbòlics a scripts situats en /etc/init.d/. P.e.:

        /etc/rcS.d/S35mountall.sh -> ../init.d/mountall.sh

        /etc/rc2.d/K45apache -> ../init.d/apache

on:

- S,K: indiquen script a executar al iniciar-se (S: start) o finalitzar-se (K: Kill) el nivell

- nombre natural: ordre d'execució (en l'exemple 35, 45)

- nom: normalment nom de l'script situat en /etc/init.d

## Fitxer de configuració
El nivell d'execució s'especifica en el fitxer `/etc/inittab`:

`id:2:initdefault:`

O bé en el fitxer `/etc/init/rc-sysinit.conf`:

`env DEFAULT_RUNLEVEL=2`

En els dos casos, el nivell d'execució és el 2

## Comandes útils
• Per saber el nivell d'execució actual: $ runlevel

• Per canviar el nivell: $ init 4 // canvia al nivell 4


 