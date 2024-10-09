# Usuaris i Grups

	• Fitxers de configuració d'usuaris: 

		/etc/passwd

		/etc/shadow

	• Fitxer de configuració de grups: 

		/etc/group



## Fitxer `/etc/passwd`


	• Camps (separats per “:”): \vskip -.5cm

		Login name \vskip -.5cm

		Optional encrypted password \vskip -.5cm

		Numerical user ID \vskip -.5cm

		Numerical group ID \vskip -.5cm

		User name or comment field \vskip -.5cm

		User home directory \vskip -.5cm

		User command interpreter 

	• Exemple:

		francesc:x:1000:1000:Francesc Solsona:/home/francesc:/bin/bash



## Fitxer `/etc/shadow`


	• Camps (separats per “:”): 

		Login name 

		Encrypted password 

		Days since Jan 1, 1970 that password was last changed 

		Days before password may be changed 

		Days after which password must be changed 

		Days before password is to expire that user is warned 

		Days after password expires that account is disabled 

		Days since Jan 1, 1970 that account is disabled 

		Reserved field 

	• Exemple:

		francesc : $1$Me/cGKsG$5ui/abvo44aqeY9BF790c0 : 12430 : 0 : 99999:7 : : :


## Fitxer `/etc/group`


	• Camps (separats per “:”): 

		name of the group.

		the (encrypted) group password.

		numerical group ID.

		group member's user names, separated by commas. 

	• Exemple:

		.................................................

		sudo:x:27:francesc, joan, sara

		audio:x:29:francesc,pep

		video:x:44:francesc

		.................................................



### Possibles aplicacions (sudo)


	• Si executem com un usuari normal:

		$ poweroff

		poweroff: must be superuser

		– El sistema ens indica que no tenim permisos suficients per executar la comanda poweroff

	• La comanda sudo ens permet executar als usuaris normals aplicacions amb permisos de superusuari. Per exemple:

		$ sudo poweroff
