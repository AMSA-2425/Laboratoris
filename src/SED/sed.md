# SED

- La comanda sed és un editor orientat a línia no interactiu.
- El funcionament bàsic d’aquesta comanda és la següent:
	- Rep un text d’entrada (des de l’entrada estàndard o des d’un fitxer)‏
	- Realitza operacions sobre totes o un subconjunt de les línies de text d’entrada,  processant una línia en cada moment.
	- El resultat s’envia a la sortida estàndard.
- Sintaxi:

 ```sh
 	$ sed operació [fitxer... ]     
   ```

- L’especificació de l’operació a realizar per la comanda sed té el format següent:

    ```sh
    [ adreça[ , adreça ] ] comanda
    ```
- Les adreces decideixen el rang de línies de text sobre les que s’aplicarà la comanda.
- El rang de línies sobre les que es realitzarà el processament es pot especificar de dues formes:
	- Rang d’adreces.
		S’especifica amb la línia inicial i la final del rang (ambdues incloses).
		Per referenciar el final de línia s’utilitza un $.
	- Patró de coincidència.
		S’utilitza una expressió regular per decidir el conjunt de línies a processar per la comanda sed.
		
Exemples:
```sh
    $ sed ‘1,5d’ fich1  # Elimina les cinc primeres línies de fich1
    $ sed ‘$d’ fich1  		# Elimina l’última línia de fich1
    $ sed ‘/^[1a]/d’ fich1  # Elimina totes les línies que comencen amb 1 o a
			            	# /^[1a]/  és una expressió regular
```
 ## Comandes SED més importants
 
- Comanda d’impressió ([rang-adreces]/p)‏
	Imprimeix les línies seleccionades.
- Comanda d’esborrar ([rang-adreces]/d)‏
	Les línies seleccionades d’entrada són eliminades, imprimint la resta de línies per pantalla.
- Comanda de substitució ([rang-adreces]/s/patró1/patró2/)‏
	Substitueix la primera instància de patró1 per patró2 en cada línia seleccionada.
- Comanda de lectura d’un fitxer ([rang-adreces]/r nom_fic)‏
- Comanda d’escriptura d’un fitxer ([rang-adreces]/w nom_fic)‏

 ## Exemples
 
 - Eliminar totes les línies en blanc:

```sh
	$ sed  '/^$/d’ fic
```
	
- Imprimir totes les línies des del principi fins la primera línia en blanc:

```sh
	$  sed  –n  '1,/^$/p’ fic
```

- Substituir la primera ocurrència de la paraula Windows per la paraula Linux en cadascuna de las línies del fitxer:

```sh
	$ sed  's/Windows/Linux/’ fic
```

- Esborrar tots els espais en blanc al final de cada línia: 

```sh
	$ sed  's/*$//’ fic
```

- Canvia totes les seqüències d’un o més zeros per un únic 0. La g permet múltiples substitucions en una mateixa línia:

```sh
	$ sed  's/00*/0/g’ fic
```
