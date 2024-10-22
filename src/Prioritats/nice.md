## Nice

### Introducció

• nice executa una comanda (programa) modificant (augmentant o disminuint-li) la prioritat.

• El rang de prioritats va des de -20 (prioritat més alta) fins 19 (més baixa). 

• Per defecte, es disminueix la prioritat en 10.

• Els usuaris normals només poden decrementar la prioritat. Augmentar la prioritat sol ho pot fer root.


Format de la comanda:

```bash
# nice [-n increment/decrement] [COMANDA [ARG]...] 
```

on increment = sencer negatiu i decrement = sencer positiu.

### Exemples

Suposem que disposem de dos scripts idèntics (`escriure1` i `escriure`):

```bash
#!/bin/bash 
while : ; do 
	let "a = ($a + 1) % 10" ; 
	echo -n "$a" ; 
done 
```
Executem:

1.
	```bash
	$ escriure &
	```

2.
	```bash
	$ top 
	PID    PRI     NI     STAT    %CPU    TIME   COMMAND 
	1002   25      0       R      70.2    1:27   escriure 
	```

3.
	```bash
	$ nice -n -10 escriure & 
	nice: no se puede establecer la prioridad: Permiso denegado
	```


4.
	```bash
	$ nice -n 10 escriure & 
	```

5.
	```bash
	$ top 
	PID     PRI     NI     STAT    %CPU    TIME    COMMAND 
	1052    35      10      R      30.2    1:27    escriure
	```

6.
	```bash
	# nice escriure& nice -n -10 escriure1 &
	```

7.
	```bash
	$ top 
	PID     PRI     NI     STAT    %CPU   TIME    COMMAND 
	3840    15     -10      R      46.5   1:14    escriure1
	3839   35       10      R      14.9   0:25    escriure 
	```