# Nohup

-  En aquest capítol veurem un exemple bash de la comanda nohup.

- nohup permet executar una comanda, abandonar la sessió, dexant
	la comanda executant-se. Quan tornem a entrar a la sessió veurem
	l'estat de  la comanda.

Exemple:

```bash
#!/bin/bash

# Nohup. Script equivalent a la comanda nohup. Exemple: $ nohup escriure & 

# Continua l'execució de la comanda en background tot i abandonar el sistema.

# Sortida standard (i també d'errors) readreçades a nohup.out

trap '' HUP  		# ignora senyal hangup. No hi ha cap funció associada

exec 0< /dev/null 	# desconnecta l'entrada standard

if [ -t 1 ]; then 		# la sortida stàndard està associada a un terminal? 

    if [ -w . ]; then 	# l'usuari té permís d'escriptura en ./ 

            echo 'Enviant sortida a nohup.out'

            exec >> nohup.out   # readreça sortida standard

    else echo "Enviant sortida a $HOME/nohup.out" && \
			exec >> $HOME/nohup.out

    fi

fi 

# readreçament de la sortida d'errors si es necessari

[ -t 2 ] && echo "Enviant sortida d'errors a nohup.out" && exec 2>&1

$@ 	# executa la comanda

exit 0

```