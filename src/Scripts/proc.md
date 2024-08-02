# Explorant /proc

En aquest laboratori utilitzareu bash,awk i altres eines per explorar el sistema de fitxers procfs. Aquest sistema de fitxers virtual conté informació sobre el sistema i els processos en execució.

## Tasques

1. Investigació sobre el sistema de fitxers /proc



Introducció al sistema de fitxers /proc
Explica què és el sistema de fitxers /proc i la seva importància en l’administració de sistemes.
Demana als estudiants que executin ls /proc per veure els fitxers i directoris disponibles.
Exploració detallada de fitxers i directoris clau
/proc/cpuinfo: Explica que aquest fitxer conté informació sobre la CPU. Demana als estudiants que executin cat /proc/cpuinfo i discuteix els resultats.
/proc/meminfo: Explica que aquest fitxer conté informació sobre la memòria. Demana als estudiants que executin cat /proc/meminfo i discuteix els resultats.
/proc/sys: Explica que aquest directori permet modificar paràmetres del kernel en temps real. Demana als estudiants que explorin els subdirectoris i fitxers.
Comandes avançades
sysctl: Explica que aquesta comanda permet obtenir o establir paràmetres del kernel. Demana als estudiants que executin sysctl -a per veure tots els paràmetres del kernel.
vmstat: Explica que aquesta comanda proporciona informació sobre l’ús de la memòria, els processos, les interrupcions del sistema, etc. Demana als estudiants que executin vmstat i discuteix els resultats.
Exercicis pràctics avançats
Demana als estudiants que modifiquin un paràmetre del kernel utilitzant sysctl i que verifiquin el canvi.
Proposa un problema de rendiment o de xarxa i demana als estudiants que l’investiguin utilitzant informació de /proc.


\chapter{Sistema de fitxers /PROC}
El directori /proc \'es un pseudo-sistema de fitxers que actua d'interf\`icie amb les estructures de dades internes del nucli. 

Caracter\`istiques:

\begin{itemize}
\item	El directori /proc \'es un disc RAM muntant en /proc. 
\item	 La major part d'aquest sistema de fitxers s'utilitza per obtenir informaci\'o sobre el sistema (acc\'es nom\'es lectura), per\`o alguns fitxers permeten canviar certs par\`ametres del nucli en temps d'execuci\'o.
\item	El sistema consta de dos grans grups d'informaci\'o:
\begin{enumerate}
\item	Informaci\'o dels processos en execuci\'o.
\item	Informaci\'o del sistema
\end{enumerate}
\end{itemize}

\section{Informaci\'o dels processos en execuci\'o}

\begin{itemize}
\item	El directori /proc cont\'e un subdirectori per cada proc\'es que s'estigui executant en el sistema.
\item	Aquests subdirectoris s'identifiquen amb el pid del proc\'es en execuci\'o. Per exemple, la informaci\'o corresponent al proc\'es init es localitza en el directori \' /proc/1\'.
\item	Cada un d'aquests subdirectoris contenen els pseudo-fitxers i directoris seg\"uents: 

	cmdline, cwd, cpu, environ, exe, fd, maps, mem, mounts, root, stat, statm, status.
\end{itemize}

\subsection{cmdline - arxiu}
Cont\'e la línia d'ordres completa de crida al proc\'es (sempre que el proc\'es no hagi estat susp\`es o que es tracti d'un proc\'es zombi).

\subsection{cwd - enlla\c c simb\`olic}
Enlla\c c al directori de treball actual del proc\'es.

\subsection{environ - arxiu}
Cont\'e l'entorn del proc\'es. Les entrades estan separades per car\`acters nuls.
 

\subsection{exe - enlla\c c simb\`olic}
Enlla\c c a el fitxer binari que va ser executat a l'arrencar aquest proc\'es.

\subsection{fd - directori}
Subdirectori que cont\'e una entrada per cada fitxer que t\'e obert el proc\'es. Cada entrada \'es un enlla\c c simb\`olic a el fitxer real i utilitza com a nom el descriptor de l'arxiu.

Exemple:
\texttt{> ls -la /proc/2354/fd}

\texttt{lr-x------	1 Joan wheel 64 feb 24 09:35 0 -> /dev/null}

\texttt{l-wx------	1 Joan	wheel	64 feb 24 09:35 1 -> /home/Joan/.xsession-errors}

\texttt{l-wx------	1 Joan	wheel	64 feb 24 09:35 2 -> /home/Joan/.xsession-errors}

\texttt{lrwx------	1 Joan	wheel	64 feb 24 09:35 3 -> socket:[3634]}

\subsection{maps - arxiu}
Cont\'e les regions de mem\`oria actualment associades amb el proc\'es i els seus permisos d'acc\'es.
El format de l'arxiu \'es el seg\"uent :
Adre\c ca	perms	despla\c c	disp	nodo-i	pathname

\texttt{08048000-0804b000 r-xp	00000000 03:06 784954	/bin/sleep}
\texttt{0804b000-0804c000 rw-p	00002000 03:06 784954	/bin/sleep}
\texttt{0804c000-0804e000 rwxp	00000000	00:00 0}
\texttt{40000000-40011000 r-xp	00000000	03:06 735844	/lib/ld-2.2.5.so}
\texttt{40011000-40012000 rw-p	00010000	03:06 735844	/lib/ld-2.2.5.so}

\subsection{mem - arxiu}		
Permet l'acc\'es a la mem\`oria del proc\'es.

\subsection{root - enlla\c c simb\`olic)}
Apunta a l'arrel de sistema de fitxers del proc\'es.

\subsection{stat - arxiu}
Cont\'e informaci\'o d'estat del proc\'es.
Entre altra informaci\'o cont\'e: identificador del proc\'es, nom, estat, PPID, distribuci\'o del temps d'execuci\'o (usuari/sistema), quantum, prioritat, quan es va llan\c car el proc\'es, mida de mem\`oria del proc\'es, valor actual del registre esp i eip, senyals pendents/bloquejades/ignorades/capturades, etc.

\subsection{statm - arxiu}
Aporta informaci\'o sobre la mem\`oria del proc\'es: mida total programa, mida conjunt resident, p\`agines compartides, p\`agines de codi, p\`agines de dades/pila, p\`agines de llibreria i p\`agines modificades.
 

\subsection{status - arxiu}
Cont\'e part de la informaci\'o dels fitxers stat y statm, per\`o en un format m\'es amigable per a l'usuari.

Exemple:

\texttt{ > more /proc/self/status}
 
\texttt{Name:	more   State:	R (running) Pid:	13717}

\texttt{PPid:	13371}

\texttt{TracerPid:	0}

\texttt{Uid:	501	501	501	501}

\texttt{Gid:	501	501	501	501}

\texttt{FDSize: 32}

\texttt{Groups: 501 4 6 10 19 22 80 81 101 102 103 104}

\texttt{VmSize:	1552 kB}

\texttt{VmLck:	0 kB}
 
\texttt{VmRSS:	512 kB}

\texttt{VmData:	44 kB}

\texttt{VmStk:	20 kB}

\texttt{VmExe:	24 kB}

\texttt{VmLib:	1196 kB}

\texttt{SigPnd: 0000000000000000}

\texttt{SigBlk: 0000000000000000}

\texttt{SigIgn: 8000000000000000}

\texttt{SigCgt: 0000000008080006}


\section{Informaci\'o del sistema}

La resta de fitxers del directori /proc proporcionen informaci\'o sobre el nucli i l'estat del sistema que s'est\`a executant.

Depenent de la configuraci\'o del nucli i dels m\`oduls carregats en el sistema, alguns dels fitxers enumerats a continuaci\'o poden no estar presents:

cmdline, cpuinfo, devices, filesystems, interrupts, kcore, ksyms, loadavg, meminfo, modules, mounts, net, partitions, pci, stat, sys, version.


\subsection{cmdline - arxiu}
Cont\'e els par\`ametres passats al nucli durant la seva arrencada.

\subsection{cpuinfo - arxiu}
Cont\'e informaci\'o sobre el processador de sistema (tipus de processador, freq\"u\`encia de rellotge, mida mem\`oria cache, pot\`encia en bogomips, ...). La informaci\'o mostrada pot variar d'un processador a un altre.

Exemple: 

\texttt{> cat /proc/cpuinfo}

\texttt{processor	: 0}

\texttt{vendor\_id	: GenuineIntel cpu family	: 6}

\texttt{model	: 42}

\texttt{model name    : Intel® Core(TM) i7-2620M CPU @ 2.70GHz}

\texttt{CPU Mhz: 2693.860}

\texttt{cache size: 4096 KB core id: 0}

\texttt{cpu cores: 1}

\texttt{fpu: yes}

$\ldots$

\texttt{flags	: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm}

\texttt{Bogomips : 5387.72}

\texttt{Address sizes: 36 bits physical, 48 bits virtual}
 
\subsection{devices - arxiu}
Mostra els dispositius actualment configurats en  el sistema, classificats en dispositius de car\`acters i de blocs.

\subsection{filesystems - arxiu}
Cont\'e	informaci\'o	sobre	els	sistemes	de	fitxers	suportats pel sistema operatiu.

\subsection{interrupts - arxiu}
Mostra informaci\'o de les interrupcions per a cada IRQ d'una arquitectura x86 (IRQ, nombre d'interrupcions, tipus de interrupci\'o i nom de dispositiu associat).
 
\subsection{kcore - arxiu}
Representa la mem\`oria física del sistema, en format simi- lar als fitxers core.

\subsection{ksyms - arxiu}
Taula de definici\'o dels símbols del nucli. Aquestes defini- cions s\'on utilitzades per enlla\c car m\`oduls.

\subsection{loadavg - arxiu}
Mostra la c\`arrega mitjana del processador (nombre mitj\`a de treballs a la cua d'execuci\'o en els darrers 1, 5 i 15 minuts, processos en execuci\'o/total i últim proc\'es executat).
Exemple: 2.10 1.98 1.95 3/87 14020
 
\subsection{meminfo - arxiu}
Cont\'e informaci\'o sobre la quantitat de mem\`oria lliure i usada en el sistema (tant física com d'intercanvi) així com de la mem\`oria compartida i els buffers utilitzats pel nucli.

Exemple:

\texttt{\# more /proc/meminfo}

\texttt{MemTotal:	4044348 kB}

\texttt{MemFree:	2036068 kB	Real free Memory}

\texttt{MemAvailable: 3130212 kB	Estimation of available Memory}

\texttt{Mlocked:	32 kB}

\texttt{SwapTotal:	978540 kB}

\texttt{SwapFree:	978540 kB}
 
\subsection{stat - arxiu}
Cont\'e informaci\'o sobre (entre d'altra):
cpu: temps d'usuari, baixa prioritat (nice), sistema, idle, espera de I/O, servint interrupcions h/w, servint interrupcions s/w, etc.
ctxt: n\'umero de canvis de context processes: \# de forks procs\_running: processos executant

Exemple:

\texttt{\# more /proc/stat}
\texttt{cpu	8736 7931 3293 238176 2157 0 714 0 0 0}
\texttt{cpu0 8736 7931 3293 238176 2157 0 714 0 0 0}
\texttt{ctxt 1692161}
\texttt{processes 18451}
\texttt{procs\_running 3}
 
\subsection{modules - arxiu}
Cont\'e un llistat dels m\`oduls carregats en el sistema, especificant el nom del m\`odul, la mida en mem\`oria, si est\`a actualment carregat (1) o no, i l'estat del m\`odul.

\subsection{net - directori}
Cont\'e informaci\'o referent a diversos par\`ametres i estadístiques de la xarxa.

\subsection{mounts - arxiu}
Mostra informaci\'o relativa a tots els sistemes de fitxers muntats en el sistema.

\subsection{partitions - arxiu}
Mostra les particions existents (dispositiu major i menor, nombre de blocs i el seu nom).

\subsection{pci - arxiu}
Cont\'e la llista de tots els dispositius PCI trobats durant la inicialitzaci\'o del nucli i les seves configuracions respect- tives.

\subsection{sys - directori}
Directori que cont\'e variables del nucli. Aquests par\`ametres es poden llegir/modificar mitjan\c cant sysctl.

\subsection{version - arxiu}
Aquesta	cadena	identifica	la	versi\'o	del	nucli	i	de	la distribuci\'o de Linux que s'est\`a executant actualment.

\section{Exemples}

\begin{enumerate}
\item Feu un script en bash que mostri la informació següent:
\begin{enumerate}
\item Si l’script rep un paràmetre, que serà el pid d'un procés, mostrarà el llistat de fitxers
oberts pel procés pid. Com per exemple:
\begin{verbatim}
lr-x------ 1 Francesc wheel 64 feb 24 09:35 0 -> /dev/null
l-wx------ 1 Francesc wheel 64 feb 24 09:35 1 -> /home/Nando/.xsession-errors
lrwx------ 1 Francesc wheel 64 feb 24 09:35 3 -> socket:[3634]
\end{verbatim}
\item Si l’script no rep cap paràmetre, mostrarà un llistat on sortirà el pid de cada procés actiu
del sistema, el número de fitxers que té oberts, la mida de la seva memòria virtual i la
mida de la seva memòria resident en Mem. Principal. 
Exemple:
\begin{verbatim}
Pid   #FO  MV       MR
17248  5   8856KB  3771KB
17333  10  9543KB  4012KB
1800   3   5345KB  1245KB

on:
#FO: nombre  fitxers oberts
MV: mida memòria virtual
MR: mida memòria resident
\end{verbatim}
\end{enumerate}

Solució:
\begin{verbatim}
num_files() {
   res1=`ls /proc/$1/fd` 
   counter=0
   for i in $res1
       do
           let "counter++"
       done
  echo "$counter"
}

virtual_mem() {
   res2=$(grep "VmSize" /proc/$1/status) 
   for i in $res2
      do 
           if [[ $i =~ $is_number ]]
                then 
                      res=$i
          fi
     done
   echo "$res"
}

resident_mem() {
    res3=$(grep "VmRSS" /proc/$1/status) 
    for i in $res3
       do
           if [[ $i =~ $is_number ]]
               then 
                    res=$i
           fi
      done
   echo "$res"
}


#----------------------------

#    PROGRAMA PRINCIPAL

#----------------------------

is_number='^[0-9]+$' #numeros del 0 al 9


# a) Si l'script no rep un parametre: llistat de cada proces
#  actiu amb infromacio de cadascun

if test $# -eq 0 
   then
      echo "Pid : Nombre fitxers oberts : mida Memoria Virtual : mida Memoria Resident" 
      processes=$(ls /proc)   #Llistat de tots els processos actius
      for proces in $processes                                                         
      do
         if [[ $proces =~ $is_number ]]   #Comprovant si es un pid. ***Veure Annex 1.***
            then
               files=$(num_files $proces)    # ***Veure Annex 2.*** Guarda resultat funcio num_files() 
                    if [ $files -gt 0 ]     #El proces te un o mes fitxers oberts (la funcio ha retornat alguna cosa)
                        then
                            virtual=$(virtual_mem $proces)    # ***Veure Annex 3.*** Guarda resultat retornat per                                  		                                                               #  la funcio virtual_mem
                           resident=$(resident_mem $proces )    # ***Veure Annex 3.*** Guarda resultat                  
                                                                                        # retornat per la funcio resident_mem
                           echo "$proces $files $virtual kb  $resident kb" 
                    fi    
       fi
   done

# b) Si l'script rep un parametre (pid proces): llistat de 
# fitxers oberts pel procés pid

else 
   if [[ $1 =~ $is_number ]]     #Comprovant si el parametre es numeric
      then 
          res=$(ls -la /proc/$1/fd)      # *** Veure Annex 4***
          echo "$res"
      else 
         echo "El parametre $1 no es valid."
   fi
fi



#                                     *** Annex 1: ***
#----------------------------------------------------------------------------------------------
# El directori /proc conté un subdirectori per cada proces que s'esta executant en el sistema.
# Aquests subdirectoris s'identifiquen amb el pid del proces en execució. A més, s'hi contenen
# pseudo-fitxers i directoris com ara cmdline. En aquest cas, nomes ens ineterssa explorar els 
# processos actius (i no els directoris o pseudo-fitxers), es per aixo que descartem tot allo
# que no sigui un pid (un numero).


#                                     *** Annex 2: ***
#----------------------------------------------------------------------------------------------
# Funcio que compta el nombre de fitxers oberts que te un proces. Aquesta infromacio l'obtenim
# tot accdint al subdirectori de /proc fd. Com que conte una entrada per cada fitxer obert d'un 
# proces, tan sols cal comptar quantes entrades diferents ens mostra l'acces a fd.


#                                     *** Annex 3: ***
#----------------------------------------------------------------------------------------------
# Funcio que retorna la mida de la memoria virtual d'un proces / la mida de la memoria resident 
# en memoria principal d'un proces. Aquesta informacio es pot trobar  accedint als directoris de 
# /proc stat, statm o be status. Per la seva claredat, s'ha decidit accedir a status.       


#                                     *** Annex 4: ***
#----------------------------------------------------------------------------------------------
# fd es un subdirectori de /proc que conte una entrada per cada fitxer que te obert el proces.

\end{verbatim}

\item Feu un script en bash que mostri en cada segon el nombre mig de processos executant-
se en la CPU durant el darrer minut, els darrers 5 i 15 minuts, així com el % de Memòria
ocupada. L’script acabarà amb Ctrl+c.

Solució
\begin{verbatim}
#!/bin/bash
while true; do   # Bucle infinit. El programa tan sols finalitzara amb Ctrl+C

    hour=$(date +"%H:%M:%S")      # Acces a la data i hora actual
    echo "Hora actual: $hour"           # Printem hora actual
    echo "---------------------------------------------"
    echo "Processos executantse a la CPU:"

    loadavg=( $(cat /proc/loadavg) )          # *** Veure Annex 1 ***
    echo "     - 1m: ${loadavg[0]}"
    echo "     - 5m: ${loadavg[1]}"
    echo "     - 15m: ${loadavg[2]}"

    meminfo=( $(cat /proc/meminfo) )      # *** Veure Annex 2 ***
    memTotal=${meminfo[1]}                                 
    activeMemory=${meminfo[19]}                            
    percent=$(( ( ${activeMemory} * 100 ) / ${memTotal} )) 
    echo "Memòria ocupada pel sistema: ${percent} %"
	
    echo ""
    echo ""
    sleep 1        # Cada segon mostrara la informacio

done


#                                     *** Annex 1: ***
#----------------------------------------------------------------------------------------------
# loadavg ens mostra infromacio sobre el sistema. Concretament, mostra la carrega mitjana del
# processador ene ls darrers 1 (posicio 0), 5 (posicio 1) i 15 minuts (posicio 2), els processos 
# en execucio/total (posicio 3) i l'ultim proces executat (posicio 4). Es per aixo que per accedir
# a la informacio requerida tan sols fara falta consultar les posicions 0, 1 i 2.


#                                     *** Annex 2: ***
#----------------------------------------------------------------------------------------------
# meminfo conte informacio sobre la quantitat de memoria lliure (posicio 1) i usada (posicio 1) 
# en el sistema aixi com la memoria compartida i els buffers utilitzats pel nucli. Per tal de 
# calcular el percentatge de memoria ocupada, cal realitzar l'operacio seguent: 
# (memoria ocupada / memoria total) * 100. La memoria ocupada es troba a la posicio 19 (Active:),
# mentre que la memoria total es troba a la posicio 1 (MemTotal).
\end{verbatim}

\item Feu un script que llisti els processos que ocupin més d’1 KByte d’un usuari que es
passarà com argument (si no es passa cap argument serà de l’usuari que ha executat l’script).
Llavors esperarà que s’entri per teclat els pid’s dels processos de la llista que haurà d’eliminar.

Solució
\begin{verbatim}
#!/bin/bash

if test $# -eq 0
   then
       username=$(logname) # a) L'usuari no es passa com a argument: agafem usuari actual
   else
       username=$1         # b) L'usuari es passa com a argument
fi


id_user=($(id -u $username))
echo "Processos que ocupen mes de 1KB de l'usuari $username amb id $id_user"
echo "-----------------------------------------------------------------------"


processes=$(ls /proc)      # Llistat de tots els processos actius 
is_number='^[0-9]+$'       # Numeros del 0 al 9
for pid_proces in $processes
do
   if [[ $pid_proces =~ $is_number ]]     # Examinarem els processos (pids) de /proc, no els directoris
      then
            info=( $(cat /proc/$pid_proces/status) ) 
            process_owner_id=${info[18]}                  # *** Veure Annex 1 ***
            if [[ "$process_owner_id" == "$id_user" ]]    # sel·leció dels processos d'usuari
                then
                     size=${info[51]}        # *** Veure Annex 2 *** 
                     if [[ $size > 1 ]]         # Si el proces ocupa mes d'1 KB
                          then
                               echo "NOM USUARI: $username   ID USUARI: $id_user   PID:$pid_proces   MIDA: $size KB"
                     fi
          fi
   fi
done

                                                              
echo "Escriu els pid's dels processos de la llista a eliminar:" 				       
read pids		# S'espera que s'entri per teclat els pid's a eliminar
for pid in $pids
do
   if [[ $pid =~ ^[0-9]+$ ]]   # Es comprova que l'usuari hagi introduit numeros (pids)
      then
            kill -9 $pid      # S'eliminen els processos amb pid especificat
  fi
done
echo "Els processos han estat eliminats."



#                                     *** Annex 1: ***
#----------------------------------------------------------------------------------------------
# La posicio 18 ens indica l'identificador de l'usuari propietari del fitxer (Uid). Aixo ens 
# servira per tal de comparar-ho amb l'identificador de l'usuari que ens interessa. Si coincideix,
# implicara que em d'analitzar aquell proces. 

#                                     *** Annex 2: ***
#----------------------------------------------------------------------------------------------
# La mida total del proces (en KB) la podem trobar a la posicio 51 del subsirectori status (VmSize).
# Caldrà comprovar si aquesta mida es superior a 1KB o no.                                              



\end{verbatim}

\item Feu un script que obtingui el nombre de fallades de pàgina produïdes des de que s’ha
arrencat el sistema.

Solució
\begin{verbatim}
#!/bin/bash

#-------------------------

#   FUNCIO AUXILIAR

#-------------------------

get_data() {
    for i in $2			  
        do 
             if [[ $i =~ $is_number ]]
                 then 
                      failures=$i
            fi
       done
echo "$failures"
}



#----------------------------

#    PROGRAMA PRINCIPAL

#----------------------------

is_number='^[0-9]+$' #numeros del 0 al 9

echo "Nombre de fallades de pagina des de que s'ha arrencat el sistema:"

# Minor faults
info1=$(grep "pgfault" /proc/vmstat)        # *** Veure Annex 1 ***
minor_faults=$(get_data $info1)
echo "- Minor Failures: $minor_faults"

# Major faults
info2=$(grep "pgmajfault" /proc/vmstat)
major_faults=$(get_data $info2)
echo "- Major Failures: $major_faults"





#                                     *** Annex 1: ***
#----------------------------------------------------------------------------------------------
# El subdirectori vmstat de /proc ens permet observar l'activitat del sistema gairebé a temps real.
# Concretament, els camps pgfault i pgmajfault ens dona informacio sobre el nombre de fallades de 
# pagina (minor fualts i major faults, respectivament) que s'han produit en el sistema des de l'última 
# arrencada del sistema.

\end{verbatim}

\end{enumerate}
