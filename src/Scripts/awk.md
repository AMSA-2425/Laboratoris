# Introducció al llenguatge AWK

**AWK** és un llenguatge de programació versàtil dissenyat per a l'exploració de patrons i el processament de text. És un excel·lent escriptor d'informes i filtres. És una característica estàndard que trobareu a la majoria de sistemes operatius semblants a Unix. Sovint s'utilitza en l'extracció de dades, transformació de dades, integració de dades o com a eina d'informes. Per exemple, els administradors de sistemes o els científics de dades poden obtenir molts beneficis d'aquesta eina.

**AWK** és petit, ràpid, senzill i té un llenguatge d'entrada net i comprensible semblant a *C*. Té construccions de programació robustes que inclouen `if/else, while, do/while`... L'eina **AWK** rep com arguments una llista de fitxers a tractar. En el cas de no tenir fitxers **AWK** llegeix de l'entrada estàndard. Per tant, podem combinar **AWK** amb les *pipes*. Començarem
a entendre la sintaxi avaluant i discutint un conjunt d'exemples dissenyat per mostrar diferents funcionalitats i avantatges d'utilitzar aquest llenguatge.

* Es pot utilitzar l'eina amb el codi escrit directament *acció-awk* sobre la shell o combinada en un script:

    ```sh
    awk [-F] '{acció-awk}' [ fitxer1 ... fitxerN ]
    ```

* Es pot utilitzar l'eina amb tota la sintaxi awk guardada en un fitxer
*script-awk* també desde de la shell o combinada amb altres scripts:

    ```sh
    awk [-F] -f script-awk [ fitxer1 ... fitxerN ]
    ```


Per realitzar tots els exemples i moltes de les activitats plantejades utilitzarem el fitxer pokedex.csv que trobareu al repositori:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08$ head pokedex.csv
1,Bulbasaur,Grass,Poison,318,45,49,49,65,65,45,1,0  
2,Ivysaur,Grass,Poison,405,60,62,63,80,80,60,1,0  
3,Venusaur,Grass,Poison,525,80,82,83,100,100,80,1,0  
4,Charmander,Fire,-,309,39,52,43,60,50,65,1,0  
5,Charmeleon,Fire,-,405,58,64,58,80,65,80,1,0  
6,Charizard,Fire,Flying,534,78,84,78,109,85,100,1,0  
7,Squirtle,Water,-,314,44,48,65,50,64,43,1,0  
8,Wartortle,Water,-,405,59,63,80,65,80,58,1,0  
9,Blastoise,Water,-,530,79,83,100,85,105,78,1,0  
10,Caterpie,Bug,-,195,45,30,35,20,20,45,1,0
```

**Cerca de patrons>**. *AWK* processa elspatrons de cerca de fitxers línia per línia. En aquest exemple, volem cercar totes les línies que coincideixin amb un patró específic. D'aquesta manera, imprimirem totes les línies que contenen el patró **Char**. Per tant, únicament 3 pokémons han de satisfer aquest patró **Charmander, Charmeleon i Charizard**. Vegem com funciona:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk '/Char/ {print}' pokedex.csv  
4,Charmander,Fire,-,309,39,52,43,60,50,65,1,0  
5,Charmeleon,Fire,-,405,58,64,58,80,65,80,1,0  
6,Charizard,Fire,Flying,534,78,84,78,109,85,100,1,0
```

Noteu que en aquesta instrucció estem cercant el patró... **NO** estem indicant que comencin pel patró, per exemple, podem buscar totes les línies del fitxer pokedex que contenen el patró **ois**:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk '/ois/ {print}' pokedex.csv  
1,Bulbasaur,Grass,Poison,318,45,49,49,65,65,45,1,0  
2,Ivysaur,Grass,Poison,405,60,62,63,80,80,60,1,0  
3,Venusaur,Grass,Poison,525,80,82,83,100,100,80,1,0  
9,Blastoise,Water,-,530,79,83,100,85,105,78,1,0  
13,Weedle,Bug,Poison,195,40,35,30,20,20,50,1,0  
14,Kakuna,Bug,Poison,205,45,25,50,25,25,35,1,0  
15,Beedrill,Bug,Poison,395,65,90,40,45,80,75,1,0  
23,Ekans,Poison,-,288,35,60,44,40,54,55,1,0  
24,Arbok,Poison,-,438,60,85,69,65,79,80,1,0  
29,Nidoran♀,Poison,-,275,55,47,52,40,40,41,1,0  
30,Nidorina,Poison,-,365,70,62,67,55,55,56,1,0  
31,Nidoqueen,Poison,Ground,505,90,92,87,75,85,76,1,0  
32,Nidoran♂,Poison,-,273,46,57,40,40,40,50,1,0  
33,Nidorino,Poison,-,365,61,72,57,55,55,65,1,0  
34,Nidoking,Poison,Ground,505,81,102,77,85,75,85,1,0  
41,Zubat,Poison,Flying,245,40,45,35,30,40,55,1,0  
42,Golbat,Poison,Flying,455,75,80,70,65,75,90,1,0  
43,Oddish,Grass,Poison,320,45,50,55,75,65,30,1,0  
44,Gloom,Grass,Poison,395,60,65,70,85,75,40,1,0  
45,Vileplume,Grass,Poison,490,75,80,85,110,90,50,1,0  
48,Venonat,Bug,Poison,305,60,55,50,40,55,45,1,0  
49,Venomoth,Bug,Poison,450,70,65,60,90,75,90,1,0  
69,Bellsprout,Grass,Poison,300,50,75,35,70,30,40,1,0  
70,Weepinbell,Grass,Poison,390,65,90,50,85,45,55,1,0  
71,Victreebel,Grass,Poison,490,80,105,65,100,70,70,1,0  
72,Tentacool,Water,Poison,335,40,40,35,50,100,70,1,0  
73,Tentacruel,Water,Poison,515,80,70,65,80,120,100,1,0  
88,Grimer,Poison,-,325,80,80,50,40,50,25,1,0  
89,Muk,Poison,-,500,105,105,75,65,100,50,1,0  
92,Gastly,Ghost,Poison,310,30,35,30,100,35,80,1,0  
93,Haunter,Ghost,Poison,405,45,50,45,115,55,95,1,0  
94,Gengar,Ghost,Poison,500,60,65,60,130,75,110,1,0  
109,Koffing,Poison,-,340,40,65,95,60,45,35,1,0  
110,Weezing,Poison,-,490,65,90,120,85,70,60,1,0
```

Com hem vist estem imprimint (print) {**ACCIÓ**}totes les línies que contenen el {**PATRÓ**}**Char**> o "**ois**. D'aquesta manera, també podem fer el mateix però imprimint el contingut d'una variable. Per exemple si fem `print $0` que denota la línia sencera obtindrem el mateix output.

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk '/Char/ {print $0}' pokedex.csv  
4,Charmander,Fire,-,309,39,52,43,60,50,65,1,0  
5,Charmeleon,Fire,-,405,58,64,58,80,65,80,1,0  
6,Charizard,Fire,Flying,534,78,84,78,109,85,100,1,0
```

Què passa si no volem tota la informació! I només ens interessa un subconjunt d'informació. Per tant, ara no volem tota la línia. D'acord, cap problema, fem-ho.

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk '/Char/ {print $1}' pokedex.csv  
4,Charmander,Fire,-,309,39,52,43,60,50,65,1,0  
5,Charmeleon,Fire,-,405,58,64,58,80,65,80,1,0  
6,Charizard,Fire,Flying,534,78,84,78,109,85,100,1,0
```

Ups! Això no funciona. En primer lloc, hem de dir a awk quin és el separador de línies **-F(fs)** per poder dividir la línia en cols i decidir en l'acció d'impressió quines columnes volem. En el nostre cas, indicarem que volem dividir el fitxer *pokedex.csv* amb "," i imprimirem només el nom del pokémon (columna nº 2).

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, '/Char/ {print $1}' pokedex.csv  
Charmander  
Charmeleon  
Charizard
```

----

**Activitat 01**: Completeu la comanda per filtrar tots els pokémons de tipus foc (Fire) i imprimir el nom i els seus dos tipus.

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F,'?????' pokedex.csv  
Charmander Fire -  
Charmeleon Fire -  
Charizard Fire Flying  
Vulpix Fire -  
Ninetales Fire -  
Growlithe Fire -  
Arcanine Fire -  
Ponyta Fire -  
Rapidash Fire -  
Magmar Fire -  
Flareon Fire -  
Moltres Fire Flying
```

---

Una funcionalitat molt interessant del llengutatge **AWK**, són les expressions regulars (REGEX) que permeten definicions de patrons dinàmiques i complexes. No us limiteu a cercar cadenes simples, sinó també patrons dins dels patrons.

* Imagineu que volem imprimir totes les línies que continguin una **'b'** o una **'B'** seguida de **"ut"**.

    ```shell
    root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, '/[bB]ut/ {print $2}' pokedex.csv  
    Butterfree  
    Kabuto  
    Kabutops
    ```

* **!Compte:** Per defecte, les expressions regulars actuen sobre tota la línia **$0**. Imagineu que volem imprimir totes les línies que el nom del pokémon (**$2**) començin per una **'b'** o una **'B'** . Si apliquem la següent expressió regular no funcionarà, ja que el inici **^** de **$0** serà un enter.

    ```shell
    root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F,'/^[bB]/ {print $2}' pokedex.csv
    ```
    
    Per tant, per aplicar o no aplicar la expressió regular a una columna determinada necessitem (**\~, !\~**):

    ```shell
    root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F,'$2 \~ /^[bB]/ {print $2}' pokedex.csv
    Bulbasaur  
    Blastoise  
    Butterfree  
    Beedrill  
    Bellsprout
    ``` 

A més, podem cercar utilitzant diverses regles, per exemple, si volem obtenir els pokémons que coincideixin amb el *patró 1* o e*l patró 2*, com el tipus de *foc* o el tipus de *lluita*. 

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, '/Fire|Fight/ {print $2,$3,$4}' pokedex.csv  
Charmander Fire -  
Charmeleon Fire -  
Charizard Fire Flying  
Vulpix Fire -  
Ninetales Fire -  
Mankey Fighting -  
Primeape Fighting -  
Growlithe Fire -  
Arcanine Fire -  
Poliwrath Water Fighting  
Machop Fighting -  
Machoke Fighting -  
Machamp Fighting -  
Ponyta Fire -  
Rapidash Fire -  
Hitmonlee Fighting -  
Hitmonchan Fighting -  
Magmar Fire -  
Flareon Fire -  
Moltres Fire Flying
```

o:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, '/Fire/ || /Fight/ {print $2,$3,$4}' pokedex.csv  
Charmander Fire -  
Charmeleon Fire -  
Charizard Fire Flying  
Vulpix Fire -  
Ninetales Fire -  
Mankey Fighting -  
Primeape Fighting -  
Growlithe Fire -  
Arcanine Fire -  
Poliwrath Water Fighting  
Machop Fighting -  
Machoke Fighting -  
Machamp Fighting -  
Ponyta Fire -  
Rapidash Fire -  
Hitmonlee Fighting -  
Hitmonchan Fighting -  
Magmar Fire -  
Flareon Fire -  
Moltres Fire Flying
```

També podem fer servir l'operació **&&**, per filtrar pokémons que coincideixin amb els dos tipus:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, '/Fire/ && /Fight/ {print $2,$3,$4}' pokedex.csv  
Charizard Fire Flying  
Moltres Fire Flying
```

El patró predeterminat és quelcom que coincideix amb totes les línies com hem vist fins a aquest punt. No obstant això, **AWK** té altres dos patrons importants que s'especifiquen per les paraules clau:

* **{BEGIN}**: Accions que s'han de dur a terme abans de llegir qualsevol línia.
* **{END}**: accions que s'han de dur a terme després de llegir l'última línia.

Ara utilitzarem aquests patrons per implementar comptadors, primer de tot simularem el comportament de la comanda `wc -l < fitxer` que compta totes les línies del fitxer.

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk ' \
BEGIN { print "Counting pokemons..." } \
{ ++n } \
END{ print "There are ", n, "pokemons." }' pokedex.csv
Counting pokemons...
There are 151 pokemons.
```

Tingueu en compte que la clàusula **{BEGIN}** s'executa ABANS de processar qualsevol línia, llavors el comptador **++n** s'executa al processsar cada línia i finalment **{END}** s'executa després de processar les línies. A més, el llenguatge **AWK** utilitza els operadors aritmètics comuns a l'hora d'avaluar expressions. En aquesta mostra, definim una variable **n** (el comptador) i incrementem 1 a cada iteració. Per tant, els operadors aritmètics segueixen les regles de precedència normals i funcionen com esperaries.

Ara, simularem el comportament del fitxer de filtre `grep pattern| wc -l` que compta totes les línies del fitxer que contenen el patró *pattern*.

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk ' \
BEGIN { print "Counting pokemons..." } \
/Fire/ { ++n } \
END{ print "There are ", n, "fire type pokemons." }' pokedex.csv
Counting pokemons...
There are 12 fire type pokemons.
```

Com hem vist *AWK** treballa dividint l'entrada en camps (columnes) i això fa que **AWK* inicialitzi un conjunt de variables internes:


| Variable  | Contingut                                                                                                                                                 |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| $0        | Conté tot el registre actual                                                                                                                             |
| NF        | Conté el valor del camp (columna) actual.                                                                                                                 |
| $1,$2..., | $1 conté el valor del primer camp i així fins l'últim camp. noteu que $NF serà substituït al final pel valor de l'últim camp.                             |
| NR        | Índex del registre actual. Per tant, quan es processa la primera línia aquesta variable té el valor 1 i quan acaba conté el nombre de línies processades. |
| FNR       | Índex del fitxer actual que estem processant.                                                                                                             |
| FILENAME  | Nom del fitxer que estem processant.                                                                                                                      |


* Indicarem a quina línia es troba cada pokémon del tipus foc. Formatant també la seva sortida:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, '/Fire/ {print "Line: ", NR "\\t" $2}' pokedex.csv  
Line: 4    Charmander  
Line: 5    Charmeleon  
Line: 6    Charizard  
Line: 37    Vulpix  
Line: 38    Ninetales  
Line: 58    Growlithe  
Line: 59    Arcanine  
Line: 77    Ponyta  
Line: 78    Rapidash  
Line: 126   Magmar  
Line: 136   Flareon  
Line: 146   Moltres
```

Les sentències condicionals s'utilitzen en qualsevol llenguatge de programació per executar qualsevol sentència basada en una condició particular. Es basa en avaluar el valor true o false en les declaracions `if-else i if-elseif`. **AWK** admet tot tipus de sentències condicionals com altres llenguatges de programació. Suposem que volem conèixer tots els pokémons llegendaris al nostre conjunt de dades. Tingueu en compte que, a les nostres dades, un 0 a la columna número 13 indica tipus normal i 1 indica llegendari. Per destacar, filtrar o fer accions amb pokémons normals i llegendaris, podem utilitzar una declaració condicional com ara:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, \  
'/Fire/ { if ($13 == 1)  
  print $2 " => LEGENDARY"  
else  
  print $2 " => ORDINARY "  
}' pokedex.csv  
Charmander => ORDINARY  
Charmeleon => ORDINARY  
Charizard => ORDINARY  
Vulpix => ORDINARY  
Ninetales => ORDINARY  
Growlithe => ORDINARY  
Arcanine => ORDINARY  
Ponyta => ORDINARY  
Rapidash => ORDINARY  
Magmar => ORDINARY  
Flareon => ORDINARY  
Moltres => LEGENDARY
```

o utilitzant l'expressió:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, \  
'/Fire/ { print ($13 == 1) ? $2 " => LEGENDARY" : $2 " => ORDINARY" }' pokedex.csv  
Charmander => ORDINARY  
Charmeleon => ORDINARY  
Charizard => ORDINARY  
Vulpix => ORDINARY  
Ninetales => ORDINARY  
Growlithe => ORDINARY  
Arcanine => ORDINARY  
Ponyta => ORDINARY  
Rapidash => ORDINARY  
Magmar => ORDINARY  
Flareon => ORDINARY  
Moltres => LEGENDARY
```

---

**Activitat 02:** Completeu la comanda per obtenir la següent sortida. Bàsicament ha de comptar tots els pokémons del tipus Dragon, Fire o others.

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, '?????' pokedex.csv  
Fire:12  
Dragon:3  
Others:136
```

---

**Activitat 03:** Completeu la comanda per obtenir la següent sortida. Implementeu un filtre a
***AWK*** per imprimir el nom dels pokémons que coincideixin amb la restricció següent: tipus Fire or Fight i que el seu nom comença amb M.

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, '?????' pokedex.csv  
Mankey types[Fighting,-]  
Machop types[Fighting,-]  
Machoke types[Fighting,-]  
Machamp types[Fighting,-]  
Magmar types[Fire,-]  
Moltres types[Fire,Flying]
```

---


### Verificacions lògiques. 
Es pot utilitzar com a criteri una expressió composta amb operadors i retornar *true* o *false*.

| Operador | Significat                               |
|----------|------------------------------------------|
| \<       | Menor                                  |
| \>       | Major                                    |
| \<=      | Menor o igual                            |
| \>=      | Major o igual                            |
| ==       | Igualtat                                 |
| !=       | Desigualtat                              |
| \~       | Correspondència amb expressió regular    |
| !\~      | No correspondència amb expressió regular |
| !        | Negació                                  |
| &&       | AND                                      |
| \|\|     | OR                                       |
| ()       | Agrupació                                |

### Operacions Aritmètiques

| Operador | Aritat | Signigicat         |
|----------|--------|--------------------|
| \+       | Binari | Suma               |
| \-       | Binari | Resta              |
| \*       | Binari | Multiplicació      |
| /        | Binari | Divisió            |
| %        | Binari | Mòdul              |
| ^        | Binari | Exponent           |
| ++       | Unari  | Increment 1 unitat |
| --       | Unari  | Decrement 1 unitat |
| +=       | Binari | x = x+y            |
| -=       | Binari | x = x-y            |
| \*=      | Binari | x=x\*y             |
| /=       | Binari | x=x/y              |
| %=       | Binari | x=x%y              |
| ^=       | Binari | x=x^y              |


Anem a veure com funcionen amb exemples:

* Farem un script per revisar si la columna 5 de la pokédex que equival al total és equivalent a la suma de les columnes 6,7,8,9,10 i 11:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, '/Char/ { print $2"->Total="$5"=="($6+$7+$8+$9+$10+$11)}' pokedex.csv  
Charmander->Total=309==309  
Charmeleon->Total=405==405  
Charizard->Total=534==534
```

* Farem ara el mateix script però per calcular la mitjana aritmètica del total:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, '/Char/ { print $2"->Total="$5"=="(($6+$7+$8+$9+$10+$11)/6)"=="($5/6)}' pokedex.csv  
Charmander->Total=309==309  
Charmeleon->Total=405==405  
Charizard->Total=534==534
```

* Farem un script per obtenir quin és el pokémon més fort i més dèbil tenint en compte el valor de la columna 7 de tipus foc.

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, \
' BEGIN{  
    max=0  
    min=100  
}  
{  
    if ($3 =="Fire") {  
        n++  
        attack+=$7
        
        if ($7 \> max){  
            pmax=$2  
            max=$7  
        }  
        if ($7 \< min){  
            pmin=$2
            min=$7  
        }  
    }  
}  
END{ print "Avg(Attack):"attack/n "\nWeakest:" pmin "\nStrongest:" pmax "\n"
}' pokedex.csv  
Avg(Attack):83,9167  
Weakest:Vulpix  
Strongest:Flareon
```

**AWK** ens permet també utilitzar una funció semblant al printf de C. Permet imprimir la cadena
amb diferents formats: `printf("cadena",expr1,,expr2,...)`

|        |                                                                                              |
|--------|----------------------------------------------------------------------------------------------|
| %20s   | Es mostraran 20 caràcters de la cadena alineats a la dreta per defecte.                      |
| %-20s  | Es mostraran 20 caràcters de la cadena alineats a l'esquerra per defecte.                    |
| %3d    | Es mostrarà un enter de 3 posicions alineat a la dreta                                       |
| %03d   | Es mostrarà un enter de 3 posicions completat amb un 0 a l'esquerra i tot alineat a la dreta |
| %-3d   | Es mostrarà un enter de 3 posicions alineat a la esquerra.                                   |
| &+3d   | Idem amb signe i alineat a la dreta                                                          |
| %10.2f | Es mostrarà un nombre amb coma flotant amb 10 posicions, 2 de les quals seràn decimals.      |

Per exemple:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, \
' BEGIN{  
    max=0  
    min=100  
}  
{  
    if ($3 =="Fire") {  
        n++  
        attack+=$7
        
        if ($7 \> max){  
            pmax=$2  
            max=$7  
        }  
        if ($7 \< min){  
            pmin=$2
            min=$7  
        }  
    }  
}  
END{ printf("Avg(Attack):%4.2f \n Weakest:%s \n Strongest:%s\n",attack/n,pmin,pmax)
}' pokedex.csv  
Avg(Attack):83,9167  
Weakest:Vulpix  
Strongest:Flareon
```

### Variables definides quan executem AWK

| Variable | Valor per defecte    | Significat                                                                                               |
|----------|----------------------|----------------------------------------------------------------------------------------------------------|
| RS       | /n (Salt de línia)   | Valor que fem servir per separar els registres (entrada)                                                 |
| FS       | Espais o tabulacions | Valor que fem servir per separar els camps en l'entrada.                                                 |
| OFS      | espai                | Valor que fem servir per separar el camps en la sortida.                                                 |
| ORS      | /n (Salt de línia)   | Valor que fem servir per separar els registres (sortida).                                                |
| ARGV     | \-                   | Taula inicialitzada amb els arguments de la línia de comandes (opcions i nom del script awk s'exclouen). |
| ARGC     | \-                   | Nombre d'arguments.                                                                                      |
| ENVIRON  | Variables entorn    | Taula amb les variables entorn exportades per la shell.                                                  |



El llenguatge **AWK** també ens permet fer bucles. Anem a veure com podem fer un petit script que
ens modifiqui el separador del csv (",") per un (";"). Com si féssim un search and replace:

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08# awk -F, \
'BEGIN{OFS=";";}  
{  
    for (i=1;i\<=NF;i++)  
        printf("%s%s",$i,(i==NF)?"\\n":OFS)  
}' pokedex.csv
```

---

**Activitat 04:** Realitzar la mateixa acció sense utilitzar una estructura de bucle..


---

**Activitat 05:** Implementarem un parser per fitxers pokèdex de CSV a JSON. Aquests parser s'adaptarà de forma dinàmica al canvi en les capçaleres, el tipus de dades o la mida
de les dades. El format de sortida ha de ser:

```json
{
"pokedex":[  
 {  
 "#":1,  
 "Name":"Bulbasaur",  
 "Type 1":"Grass",  
 "Type 2":"Poison",  
 "Total":318,  
 "HP":45,  
 "Attack":49,  
 "Defense":49,  
 "Sp. Atk":65,  
 "Sp. Def":65,  
 "Speed":45,  
 "Generation":1,  
 "Legendary":"False"  
 },  
 {  
 "#":2,  
 "Name":"Ivysaur",  
 "Type 1":"Grass",  
 "Type 2":"Poison",  
 "Total":405,  
 "HP":60,  
 "Attack":62,  
 "Defense":63,  
 "Sp. Atk":80,  
 "Sp. Def":80,  
 "Speed":60,  
 "Generation":1,  
 "Legendary":"False"  
 },
 ...  
]  
}
```

Per fer-ho completeu el codi **act05/csv2json.sh**. Per testejar que funciona correctament podeu fer servir el script **act05/test.sh**.

```shell
root@os-102377-i-2122-debian-lab:\~/resources/HandsOn08/csv2json#./test.sh  
+ Running Tests +++++++++++++++++++++  
++ Running Test 1.  
### SUCCESS: Test passed files are identical ###  
++ Running Test 2.  
### SUCCESS: Test passed files are identical ###  
++ Running Test 3.  
### SUCCESS: Test passed files are identical ###  
+ Ending Tests +++++++++++++++++++++
```

Assumirem i no cal que assegureu que la primera línia està ben formatada i conté els headers. El vostre script no cal que ho testegi.

---

**Activitat 06:**  Tv Shows. Implementeu un script podeu fer servir awk i bash per transformar la informació input en la informació output.

* **Input**: act06/series.db
* **Expected**:act06/expected.txt

---

**Activitat 07:** Feu un script en *bash* utiltizant *awk* que crei un fitxer anomenat *mem_lliure.lst* (si no existeix) i si existeix no faci res. Aquest script per defecte
guardarà durant 1 minut dades extretes del `/proc/meminfo`. Aquest temps 1 minut pot ser modificat passant al script un argument com a primer paràmetre.

```sh
./act07.sh -> Actuarà durant 60 segons
./act07.sh 30 -> Actuarà durant 30 segons
```

Aquest fitxer mostrarà de forma tabulada l'evolució de la memòria total, lliure i disponible del sistema. Aquests valors s'hauran de mostrar en les unitats (Mb). Cada entrada a la taula anirà precedida d'una marca de temps. Podeu veure el fitxer sortida esperada.  
  
**Extra**: El fitxer hauria d'estar preparat per afegir i treure columnes del fitxer `/proc/meminfo`de forma relativamentsimple.</span>

**Pistes:**

* Per mostrar informació tabulada: `printf "%20s \t %12s \t %12s \t %12s \n" "Time" "MemFree" "MemTotal" "MemAvailable"`
* Per. tenir valors per defecte: `output="${1:-"mem_lliure.lst"}"`

---


![](https://lh3.googleusercontent.com/proxy/kXmvpyGoonDZe2sk-I1B4kNsP1mpw2NJ0sWb9QXsqoMT_vZv5KxbNcKQo-PkWlj-yotgJ8XMFk_qYPJU4EV92CwD9yDsn8UzyFY7Z2LxVymikPfNe97I5CNbMEt1sT_jUShWh0pv-GFmyAWkGbFpjqG-2A)