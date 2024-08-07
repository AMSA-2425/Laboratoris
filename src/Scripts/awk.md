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

En aquest laboratori utilitzarem el següent fitxer de dades com a conjunt de dades d'exemple. Aquest fitxer representa una pokedex i la podem obtenir amb la següent comanda:

```bash
curl -O  https://gist.githubusercontent.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6/raw/92200bc0a673d5ce2110aaad4544ed6c4010f687/pokemon.csv
```

O bé podeu utilitzar la còpia hostejada en aquest repositori:

```bash
curl -O XXXXXXX
```

Aquest fitxer conté 801 línies (800 pokemons + 1 capçalera) i 13 columnes. Aquestes columnes són:

* **#**: Número de pokémon
* **Name**: Nom del pokémon
* **Type 1**: Tipus 1 del pokémon
* **Type 2**: Tipus 2 del pokémon
* **Total**: Total de punts de tots els atributs
* **HP**: Punts de vida
* **Attack**: Atac
* **Defense**: Defensa
* **Sp. Atk**: Atac especial
* **Sp. Def**: Defensa especial
* **Speed**: Velocitat
* **Generation**: Generació
* **Legendary**: Llegendari (0: No, 1: Sí)

Per comprovar-ho podem fer servir les següents comandes:

* Utilitzeu la comanda **wc** per comptar el nombre de línies del fitxer:

    ```bash
    ~wc -l pokemon.csv
    ```

* Utilitzeu la comanda **head** per mostrar les primeres 10 línies del fitxer:

    ```bash
    ~head pokemon.csv
    ```

* Utilitzeu les comandes **wc** i **head** per comptar el nombre de columnes del fitxer. Recordeu que les columnes estan separades per comes:

    ```bash
    ~head -1 pokemon.csv | tr ',' '\n' | wc -l
    ```

## Sintaxis Bàsica

* Replicarem la comanda `cat` per mostrar el contingut del fitxer pokemon.csv:

    ```bash
    awk '{print $0}' pokemon.csv
    ```

    Per defecte, **AWK** imprimeix totes les línies del fitxer. En aquest cas, estem utilitzant la variable **$0** que conté tota la línia. Això és equivalent a la comanda `cat`. Per assegurar-nos que la sortida és la mateixa, podem fer servir la comanda `diff`:

    ```bash
    diff <(cat pokemon.csv) <(awk '{print $0}' pokemon.csv)
    ```

* Replicarem la comanda `grep` per mostrar totes les línies que contenen la paraula "Char" al fitxer pokemon.csv:

    ```bash
    awk '/Char/ {print}' pokemon.csv
    ```

    En aquest cas, estem utilitzant la variable **$0** que conté tota la línia i la variable **/Char/** que conté el patró a cercar. Això és equivalent a la comanda `grep`. Per assegurar-nos que la sortida és la mateixa, podem fer servir la comanda `diff`:

    ```bash
    diff <(grep Char pokemon.csv) <(awk '/Char/ {print}' pokemon.csv)
    ```

    Noteu que  *AWK* processa els patrons de cerca de fitxers línia per línia. En aquest exemple, hem cercat totes les línies que coincideixin amb un patró específic **Char**.  Per tant, únicament 3 pokémons han de satisfer aquest patró **Charmander, Charmeleon i Charizard** amb les seves versions Mega.

    ```bash
    4,Charmander,Fire,,309,39,52,43,60,50,65,1,False
    5,Charmeleon,Fire,,405,58,64,58,80,65,80,1,False
    6,Charizard,Fire,Flying,534,78,84,78,109,85,100,1,False
    6,CharizardMega Charizard X,Fire,Dragon,634,78,130,111,130,85,100,1,False
    6,CharizardMega Charizard Y,Fire,Flying,634,78,104,78,159,115,100,1,False
    ```

  No us confoneu! **NO** estem indicant que comencin pel patró, per exemple, podem buscar totes les línies del fitxer pokedex que contenen el patró **ois**:

    ```bash
    awk '/ois/ {print}' pokemon.csv
    ```

    En aquest exemple, hem cercat totes les línies que coincideixin amb un patró específic **ois**.

    ```bash
    1,Bulbasaur,Grass,Poison,318,45,49,49,65,65,45,1,False
    9,Blastoise,Water,-,530,79,83,100,85,105,78,1,False
    ...
    71,Victreebel,Grass,Poison,490,80,105,65,100,70,70,1,False
    ...
    691,Dragalge,Poison,Dragon,494,65,75,90,97,123,44,6,False
    ```

    Hi ha 64 entrades que satisferan aquest patró.

    ```bash
    awk '/ois/ {print}' pokemon.csv | wc -l
    ```

* Replicarem la comanda `cut` per mostrar només la primera columna del fitxer pokemon.csv:

    ```bash
    awk -F, '{print $1}' pokemon.csv
    ```

    En aquest cas, estem indicant que el separador de camps és la coma **-F,** i únicament volem la primera columna **$1**. Això és equivalent a la comanda `cut`. Per assegurar-nos que la sortida és la mateixa, podem fer servir la comanda `diff`:

    ```bash
    diff <(cut -d, -f1 pokemon.csv) <(awk -F, '{print $1}' pokemon.csv)
    ```

### Separadors de camps

El separador de camps per defecte és l'espai en blanc. Per tant, si no especifiquem el separador de camps, **AWK** utilitzarà l'espai en blanc com a separador de camps.

* Imprimiu la columna 3 sense especificar el separador de camps:

    ```bash
    ~awk '{print $3}' pokemon.csv
    ```

    Podeu observar que la sortida no és correcta. Això és degut a que el separador de camps per defecte és l'espai en blanc i no la coma. Per tant, hem d'especificar el separador de camps amb l'opció **-F**:

    ```bash
    ~awk -F, '{print $3}' pokemon.csv
    ```

    Podem transformar el separador de camps a qualsevol caràcter que vulguem. Utilitzarem la comanda `sed` per canviar el separador de camps de la coma a un espai en blanc i després utilitzarem **AWK** per imprimir la columna 3:

    ```bash
    ~sed 's/,/ /g' pokemon.csv | awk '{print $3}'
    ```

Fins ara estem imprimint (print) {**ACCIÓ**} totes les línies que contenen el {**PATRÓ**}**Char**> o "**ois**. D'aquesta manera, també podem fer el mateix però imprimint el contingut d'una variable. Per exemple si fem `print $0` que denota la línia sencera obtindrem el mateix output. A més a més, per poder imprimir el contingut d'una columna determinada, podem fer servir la variable **$1, $2, $3, ...** que denoten la primera, segona, tercera columna, etc. Però sempre indicant el separador de camps amb **-F**. 

Però quina avantatge té fer servir **AWK** en comptes de bash per fer aquestes tasques? **AWK** és molt més ràpid i eficient que bash per processar fitxers de text. Ara veure exemples de com **AWK** pot ser molt més eficient que bash.

### Filtres i Patrons

* Creeu una comanda per filtrar tots els pokemons de tipus foc (Foc) i imprimir el nom i els seus dos tipus.

  * Per fer-ho en bash:

    ```bash
    ~grep Fire pokemon.csv | cut -d, -f2,3,4
    ```

  * Per fer-ho en **AWK**:

    ```bash
    ~awk -F, '/Fire/ {print $2,$3,$4}' pokemon.csv
    ```

* Imprimiu totes les línies que continguin una **'b'** o una **'B'** seguida de **"ut"**.

  * En **AWK**:

    ```bash
    ~awk -F, '/[bB]ut/ {print $2}' pokemon.csv
    ```

  * En bash, podeu fer servir l'argument **-i** per ignorar la diferència entre majúscules i minúscules amb la comanda **grep**:

    ```bash
    ~grep -i "but" pokemon.csv | cut -d, -f2
    ```

* Imprimiu totes les línies que el nom començi per un **"K"** majúscula. 

  * En **AWK**:

    ```bash
    ~awk -F, '$2 ~ /^K/ {print $2}' pokemon.csv
    ```

    **!Compte:** Per defecte, les expressions regulars actuen sobre tota la línia **$0**. Si voleu aplicar l'expressió regular a una columna determinada, necessiteu (**~**). Si intenteu aplicar awk -F,'/^K/ {print $2}' pokemon.csv no funcionarà ja que l'inici **^** de **$0** serà un enter.

  * En bash:

    ```bash
    ~grep "^K" pokemon.csv | cut -d, -f2
    ```

### Operacions

* Imprimiu tots els pokemons que siguin del tipus foc o lluita. Imprimiu el nom, tipus 1 i tipus 2. Podeu fer servir l'operador **|** per crear l'expressió regular.

  * En **AWK**:

    ```bash
    ~awk -F, '/Fire|Fighting/ {print $2,$3,$4}' pokemon.csv
    ```

    * En bash, podeu fer servir l'argument **-E** per utilitzar expressions regulars exteses amb la comanda **grep**:

    ```bash
    ~grep -E "Fire|Fighting" pokemon.csv | cut -d, -f2,3,4
    ```

    Noteu que l'operador **|** és l'operador lògic OR que regula la expressió regular. També podem fer servir el mateix operador lògic **||** per aconseguir el mateix resultat però afectant a la comanda awk.

    ```bash
    ~awk -F, '/Fire/ || /Fighting/ {print $2,$3,$4}' pokemon.csv
    ```

* Imprimiu tots els pokemons que siguin del tipus foc i lluita. Imprimiu el nom, tipus 1 i tipus 2. Podeu fer servir l'operador **&&** per crear l'expressió regular.

  * En **AWK**:

    ```bash
    ~awk -F, '/Fire/ && /Fighting/ {print $2,$3,$4}' pokemon.csv
    ```

* En bash, podeu fer servir l'argument **-E** per utilitzar expressions regulars exteses amb la comanda **grep**:

    ```bash
    ~grep -E "Fire.*Fighting|Fighting.*Fire" pokemon.csv | cut -d, -f2,3,4
    ```


## Patrons

* Implimenteu un script que compti tots els pokemons que tenim a la pokedex i que tingui la sortida següent:

    ```bash
    Counting pokemons...
    There are 151 pokemons.
    ```

  * Per fer-ho en bash:

    ```bash
    !/bin/bash
    echo "Counting pokemons..." 
    n=`wc -l pokemon.csv` 
    n=`expr $n - 1`
    echo "There are $n pokemons."
    ```

    * Per fer-ho en **AWK**:

    ```bash
    ~awk 'BEGIN { print "Counting pokemons..." } { ++n } END{ print "There are ", n-1, "pokemons." }' pokemon.csv
    ```


    Tingueu en compte que la clàusula **{BEGIN}** s'executa ABANS de processar qualsevol línia, llavors el comptador **++n** s'executa al processsar cada línia i finalment **{END}** s'executa després de processar les línies. A més, el llenguatge **AWK** utilitza els operadors aritmètics comuns a l'hora d'avaluar expressions. En aquesta mostra, definim una variable **n** (el comptador) i incrementem 1 a cada iteració. Per tant, els operadors aritmètics segueixen les regles de precedència normals i funcionen com esperaries.


* Implementeu un comptador per saber tots els pokemons de tipus foc de la primera generació descartant els Mega pokemons i que tingui la sortida següent:

    ```bash
    Counting pokemons...
    There are 12 fire type pokemons in the first generation without Mega evolutions.
    ```

  * Per fer-ho en bash, podeu combinar les comandes **grep, cut, wc** i **expr**. Nota, l'argyment **-v** de **grep** exclou les línies que contenen el patró i la generació s'indica a la columna 12 amb el valor 1:

    ```bash
    !/bin/bash
    echo "Counting pokemons..."
    n=`grep Fire pokemon.csv | grep -v "Mega" | cut -d, -f12 | grep 1 | wc -l`
    n=`expr $n - 1`
    echo "There are $n pokemons in the first generation without Mega evolutions."
    ```

    * Per fer-ho en **AWK**, teniu el negador **!** per negar el patró:

    ```bash
    ~awk -F, 'BEGIN { print "Counting pokemons..." } /Fire/ && !/Mega/ && $12 == 1 { ++n } END{ print "There are ", n, "fire type pokemons in the first generation without Mega evolutions." }' pokemon.csv
    ```

    En aquest exemple, hem utilitzat l'operador lògic **&&** per combinar dos patrons. Això significa que la línia ha de contenir el patró **Fire** i no ha de contenir el patró **Mega**. Això ens permet filtrar els Mega pokemons del nostre comptador. A més, hem utilitzat l'operador **!** per negar el patró **Mega**. Això significa que la línia no ha de contenir el patró **Mega**. Finalment, hem utilitzat la clàusula **{END}** per imprimir el resultat final.



### Variables

**AWK** té variables internes que són molt útils per a la manipulació de dades. Aquestes variables són:

| Variable  | Contingut                                                                                                                                                 |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| $0        | Conté tot el registre actual                                                                                                                             |
| NF        | Conté el valor del camp (columna) actual.                                                                                                                 |
| $1,$2..., | $1 conté el valor del primer camp i així fins l'últim camp. noteu que $NF serà substituït al final pel valor de l'últim camp.                             |
| NR        | Índex del registre actual. Per tant, quan es processa la primera línia aquesta variable té el valor 1 i quan acaba conté el nombre de línies processades. |
| FNR       | Índex del fitxer actual que estem processant.                                                                                                             |
| FILENAME  | Nom del fitxer que estem processant.                                                                                                                      |

* Simplifiqueu el script `awk 'BEGIN { print "Counting pokemons..." } { ++n } END{ print "There are ", n-1, "pokemons." }' pokemon.csv` per obtenir el mateix resultat utilitzant la variable **NR**:

    ```bash
    awk 'BEGIN { print "Counting pokemons..." } END{ print "There are ", NR-1, "pokemons." }' pokemon.csv
    ```

* Indiqueu a quina línia es troba cada pokémon del tipus foc. Volem imprimir la línia i el nom del pokémon. La sortida ha de ser semblant a:

    ```bash
    Line:  6    Charmander
    Line:  7    Charmeleon
    Line:  8    Charizard
    Line:  9    CharizardMega Charizard X
    Line:  10   CharizardMega Charizard Y
    ...
    Line:  737  Litleo
    Line:  738  Pyroar
    Line:  801  Volcanion
    ```

    on el format de cada línia és **Line:  n\tNom del pokémon**.

  * En **AWK** podem fer servir la variable **NR** per obtenir el número de línia actual. A més a més, podeu formatar la sortida amb `print cadena,variable,cadena,variable,...`:

    ```bash
    ~awk -F, '/Fire/ {print "Line: ", NR, "\t" $2}' pokemon.csv
    ```

  * En bash:

    ```bash
    #!/bin/bash
    while IFS=, read -r col1 col2 rest; do
    ((line_number++))
    # Check if the line contains the word "Fire"
    if [[ "$col1" == *"Fire"* ]]; then
        echo "Line: $line_number    $col2"
    fi
    done < pokemon.csv
    ```

### Condicionals

Les sentències condicionals s'utilitzen en qualsevol llenguatge de programació per executar qualsevol sentència basada en una condició particular. Es basa en avaluar el valor true o false en les declaracions `if-else i if-elseif`. **AWK** admet tot tipus de sentències condicionals com altres llenguatges de programació. 

* Implementeu una comanda que us indiqui quins pokemons de tipus foc són ordinaris o llegendaris. Busquem una sortida semblant a:

    ```bash
    Charmander => ORDINARY
    Charmeleon => ORDINARY
    Charizard => ORDINARY
    Moltres => LEGENDARY
    ```

    Recordeu que la columna 13 indica si un pokémon és llegendari o no (0: No, 1: Sí).

  * En **AWK**:
  
    ```bash
    ~awk -F, '/Fire/ { if ($13 == 1) print $2 " => LEGENDARY"; else print $2 " => ORDINARY" }' pokemon.csv
    ```

  * En bash:

    ```bash
    #!/bin/bash
    while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13; do
    if [[ "$col3" == *"Fire"* ]]; then
        if [[ "$col13" == "1" ]]; then
        echo "$col2 => LEGENDARY"
        else
        echo "$col2 => ORDINARY"
        fi
    fi
    done < pokemon.csv
    ```

* Es poden utilitzar expressions condicionals per simplificar el codi. Per exemple, la comanda anterior es pot simplificar amb l'expressió:

    ```bash
    awk -F, '/Fire/ { print ($13 == 1) ? $2 " => LEGENDARY" : $2 " => ORDINARY" }' pokemon.csv
    ```

* Implementeu una comanda per obtenir la següent sortida. 

    ```bash
    Fire:12  
    Dragon:3  
    Others:136
    ```

    Bàsicament, es vol comptar el nombre de pokemons de tipus foc, drac i altres.

  * En **AWK**:

    ```bash
    ~awk -F, 'BEGIN{ fire=0; dragon=0; others=0 } /Fire/ { fire++ } /Dragon/ { dragon++ } !/Fire|Dragon/ { others++ } END{ print "Fire:" fire "\nDragon:" dragon "\nOthers:" others }' pokemon.csv
    ```

  * En bash:

    ```bash
    #!/bin/bash
    fire=0
    dragon=0
    others=0

    while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13; do
    if [[ "$col3" == *"Fire"* ]]; then
        ((fire++))
    elif [[ "$col3" == *"Dragon"* ]]; then
        ((dragon++))
    else
        ((others++))
    fi
    done < pokemon.csv
    ```

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

* Implementeu un script que comprovi que el Total (*columna 5*) és la suma de tots els atributs (*columnes 6,7,8,9,10 i 11*). La sortida ha de ser semblant a:

    ```bash
    Charmander->Total=309==309
    Charmeleon->Total=405==405
    Charizard->Total=534==534
    ```

  * En **AWK**:

    ```bash
    ~awk -F, '{ print $2"->Total="$5"=="($6+$7+$8+$9+$10+$11)}' pokemon.csv
    ```

  * En bash:

    ```bash
    #!/bin/bash
    while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13; do
    if [[ "$col5" == "$((col6+col7+col8+col9+col10+col11))" ]]; then
        echo "$col2->Total=$col5==$((col6+col7+col8+col9+col10+col11))"
    fi
    done < pokemon.csv
    ```

* Imprimiu la pokedex amb una nova columna que indiqui la mitjana aritmètica dels atributs de cada pokémon. La sortida ha de ser semblant a:

     ```bash
    #,Name,Type 1,Type 2,Total,HP,Attack,Defense,Sp. Atk,Sp. Def,Speed,Generation,Legendary,Avg
    1,Bulbasaur,Grass,Poison,318,45,49,49,65,65,45,1,False,53
    2,Ivysaur,Grass,Poison,405,60,62,63,80,80,60,1,False,67.5
    3,Venusaur,Grass,Poison,525,80,82,83,100,100,80,1,False,87.5
    ```

  * En **AWK**:

    ```bash
    ~awk -F, '{ if (NR==1) print $0",Avg"; else print $0","($6+$7+$8+$9+$10+$11)/6 }' pokemon.csv
    ```

  * En bash:

    ```bash
    #!/bin/bash
    while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13; do
    if [[ "$col1" == "#" ]]; then
        echo "$col1,$col2,$col3,$col4,$col5,$col6,$col7,$col8,$col9,$col10,$col11,$col12,$col13,Avg"
    else
        echo "$col1,$col2,$col3,$col4,$col5,$col6,$col7,$col8,$col9,$col10,$col11,$col12,$col13,$((col6+col7+col8+col9+col10+col11))/6"
    fi
    done < pokemon.csv
    ```

* Cerca el pokémon més fort i més feble tenint en compte el valor de la columna 7 dels pokemons de tipus foc de la primera generació.

  * En **AWK**, assumiu que el valors de la columna 7 van de 0 a 100:

    ```bash
    ~awk -F, 'BEGIN{ max=0; min=100 } /Fire/ && $12 == 1 { if ($7 > max) { max=$7; pmax=$2 } if ($7 < min) { min=$7; pmin=$2 } } END{ print "Weakest: "pmin "\nStrongest: "pmax }' pokemon.csv
    ```

  * En bash:

    ```bash
    #!/bin/bash
    max=0
    min=100
    while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13; do
    if [[ "$col3" == *"Fire"* ]] && [[ "$col12" == "1" ]]; then
        if [[ "$col7" -gt "$max" ]]; then
        max=$col7
        pmax=$col2
        fi
        if [[ "$col7" -lt "$min" ]]; then
        min=$col7
        pmin=$col2
        fi
    fi
    done < pokemon.csv
    echo "Weakest: $pmin"
    echo "Strongest: $pmax"
    ```

### Formatant la sortida

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

```bash
 awk -F, \
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

```bash
awk -F, \
'BEGIN{OFS=";";}  
{  
    for (i=1;i\<=NF;i++)  
        printf("%s%s",$i,(i==NF)?"\\n":OFS)  
}' pokedex.csv
```

* Implementeu la mateixa funció però sense utilitzar el bucle `for`:

```bash
awk -F, \
'BEGIN{OFS=";";}  
{  
    $1=$1  
    print  
}' pokedex.csv
```
