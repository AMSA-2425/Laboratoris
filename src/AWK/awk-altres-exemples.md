## Altres Exemples


###  Programa awk que imprimeix el nom dels directoris i fitxers de l’usuari francescsolsonatehas.

```bash
s -la | awk 'BEGIN{ print "Inici processament" }
	/^d/ { print "Directori "$9 }
	/^-/ && $3 == "francescsolsonatehas" {print "fitxer Francesc: "$9 }
END { print "Fi processament"}'
```
###  Sumar els camps 2 i 3 en el camp 1, i imprimir el nou registre.

```bash
	awk '{ $1 = $2 + $(2+1); print $0 }' arxiu
```

###   Renombrar els fitxers que compleixen un determinat patró.

```bash
	ls -1 patró | awk '{print "mv "$1" "$1".nou"}' | bash
```

###  El següent programa mostra la forma en que pot  calcular-se la mida mitja i total dels fitxers d’un usuari

```bash
#!/bin/bash
ls -l | awk 'BEGIN { print "comencem ..."; total=0 }
	{ total=total+$5 }
END { mitja=total/NR; print "quantitat total: " total; print "mitja: " mitja;
	print "programa executat ..." }'
exit 0
```


### Shell script per matar tots els processos amb el nom passat com argument de l’usuari actiu 

```bash
#!/bin/bash
	proces=$1
	ps –ef | \
	awk '$1~/’$USER’/&&$8~/’$proces’/&& $8!~/awk/ {print $2}’ | \
	xargs kill –9
```

### Programa awk que treballa amb vectors i sentències for. Utilitza un array anomenat `línia' per llegir un arxiu complet i després l’imprimeix en ordre invers: 

```bash
#!/bin/bash
	awk '{ línia[NR]=$0 }
	END { for(i=NR;i>0;i=i-1) { print línia[i] } }'   pr.txt
exit 0
```

###  Imprimir el número total de camps de totes les línies d’entrada. 

```bash
	awk '{ num_camps = num_camps + NF } 
	END { print num_camps }'  fitxer
```

### Imprimir totes les línies que tinguin més de 30 caràcters.
```bash	
	awk 'length($0) > 30 {print $0}' fitxer
```

### Utilitzar funcions incorporades per imprimir per pantalla 7 números aleatoris de 0 a 100.

```bash
awk 'BEGIN { for (i = 1; i <= 7; i++) 
		print 100 * rand() }’
```

### Utilitzar funcions incorporades per emmagatzemar en “fitxer” 7 números aleatoris de 0 a 100.
	
```bash
awk 'BEGIN { for (i = 1; i <= 7; i++) 
		print 100 * rand() }’ > fitxer
```


