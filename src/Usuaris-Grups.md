# Usuaris i Grups

- Fitxers de configuració d'usuaris: 

```sh
		/etc/passwd
		/etc/shadow
```

- Fitxers de configuració de grups: 

```sh
		/etc/group
		/etc/gshadow
```


## Fitxer `/etc/passwd`


- Camps (separats per “:”): 

```sh
		Login name 

		Optional encrypted password 

		Numerical user ID 

		Numerical group ID 

		User name or comment field 

		User home directory 

		User command interpreter 
```

- Exemple:

```sh
		francesc:x:1000:1000:Francesc Solsona:/home/francesc:/bin/bash
```



## Fitxer `/etc/shadow`  (Permission: rw-r-----)


- Camps (separats per “:”): 

```sh
		Login name 

		Encrypted password 

		Days since Jan 1, 1970 that password was last changed 

		Days before password may be changed 

		Days after which password must be changed 

		Days before password is to expire that user is warned 

		Days after password expires that account is disabled 

		Days since Jan 1, 1970 that account is disabled 

		Reserved field 
```

- Exemple:

```sh
		francesc : $1$Me/cGKsG$5ui/abvo44aqeY9BF790c0 : 12430 : 0 : 99999:7 : : :
```


## Fitxer `/etc/group`


- Camps (separats per “:”): 

```sh
		name of the group.

		the (encrypted) group password.

		numerical group ID.

		group member's user names, separated by commas. 
```

- Exemple:

```sh
		.................................................

		sudo:x:27:francesc, joan, pep

		audio:x:29:francesc,pep

		.................................................
```


## Fitxer `/etc/gshadow`   (Permission: rw-r-----)


- Camps (separats per “:”): 

```sh
		name of the group.

		the (encrypted) group password.

		administrator.

		group member's user names, separated by commas. 
```

- Exemple:

```sh
		.................................................

		sudo:*:root:francesc,joan,pep

		audio:Stdwue%&(((ffff4233&/(((()988:root:francesc,pep

		.................................................
```

- El " * " vol dir que ningú pot accedir amb contrasenya a part dels usuaris ue són membres del grup.


### Possibles aplicacions (sudo)


- Si executem com un usuari normal:

```sh
		$ poweroff

		poweroff: must be superuser
```


- El sistema ens indica que no tenim permisos suficients per executar la comanda 
			poweroff

- La comanda sudo ens permet executar als usuaris normals aplicacions amb permisos 
		de superusuari. Per exemple:

```sh
		$ whoami
		francesc
		$ sudo poweroff
```