# Awk - Intermedi

### Variables en AWK

El llenguatge de programació AWK ens permet definir variables i utilitzar-les en les nostres accions. Les variables en **AWK** són dinàmiques i no necessiten ser declarades abans d'utilitzar-les. Això significa que podem utilitzar una variable sense haver-la declarat prèviament.

Per exemple, si volem comptar el nombre de línies que hi ha al fitxer pokemon.csv, podem fer servir una variable per a emmagatzemar el nombre de línies. A continuació, mostrem un exemple de com comptar el nombre de línies del fitxer pokemon.csv:

```bash
awk 'BEGIN { n=0 } { ++n } END{ print n }' pokemon.csv
```

On **n** és la variable que utilitzem per emmagatzemar el nombre de línies. Per començar, inicialitzem la variable **n** a 0 amb la clàusula **{BEGIN}**. Aquesta clausula és opcional, ja que les variables en **AWK** són dinàmiques i no necessiten ser declarades prèviament. Després, incrementem la variable **n** per a cada línia amb la clàusula **{++n}**. Finalment, utilitzem la clàusula **{END}** per imprimir el valor de la variable **n** després de processar totes les línies.

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


Implementeu un script que comprovi que el Total (*columna 5*) és la suma de tots els atributs (*columnes 6,7,8,9,10 i 11*). La sortida ha de ser semblant a:

```bash
Charmander->Total=309==309
Charmeleon->Total=405==405
Charizard->Total=534==534
```

* En **AWK**:

    ```bash
    awk -F, '{ print $2"->Total="$5"=="($6+$7+$8+$9+$10+$11)}' pokemon.csv
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

### Variables Internes

**AWK** té variables internes que són molt útils per a la manipulació de dades. Aquestes variables són:

| Variable  | Contingut                                                                                                                                                 |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| $0        | Conté tot el registre actual                                                                                                                             |
| NF        | Conté el valor del camp (columna) actual.                                                                                                                 |
| $1,$2..., | $1 conté el valor del primer camp i així fins l'últim camp. noteu que $NF serà substituït al final pel valor de l'últim camp.                             |
| NR        | Índex del registre actual. Per tant, quan es processa la primera línia aquesta variable té el valor 1 i quan acaba conté el nombre de línies processades. |
| FNR       | Índex del fitxer actual que estem processant.                                                                                                             |
| FILENAME  | Nom del fitxer que estem processant.                                                                                                                      |

Per exemple:

* Utilitzeu la variable **NR** per simplificar la comanda per comptar el nombre de línies del fitxer pokemon.csv:

    ```bash
    awk 'END{ print NR }' pokemon.csv
    ```

* Traduïu la capçalera del fitxer pokemon.csv al catala. La capçalera és la següent: **# Name Type 1 Type 2 Total HP Attack Defense Sp. Atk Sp. Def Speed Generation Legendary**. La traducció és la següent: **# Nom Tipus 1 Tipus 2 Total HP Atac Defensa Atac Especial Defensa Especial Velocitat Generació Llegendari**. I després imprimiu la resta de línies del fitxer.

    ```bash
    awk 'NR==1 { $1="#"; $2="Nom"; $3="Tipus 1"; $4="Tipus 2"; $5="Total"; $6="HP"; $7="Atac"; $8="Defensa"; $9="Atac Especial"; $10="Defensa Especial"; $11="Velocitat"; $12="Generació"; $13="Llegendari"; print $0 } NR>1 {print}' pokemon.csv
    ```

* Implementeu una comanda que permeti detectar entrades incorrectes a la pokedex. Un entrada incorrecta és aquella que no té 13 valors per línia. En cas de detectar una entrada incorrecta, la eliminarem de la sortida i comptarem el nombre de línies eliminades per mostrar-ho al final.

    ```bash
    awk 'NF != 13 { n++ } NF == 13 { print } END{ print "There are ", n, "incorrect entries." }' pokemon.csv
    ```

### Condicionals

Les sentències condicionals s'utilitzen en qualsevol llenguatge de programació per executar qualsevol sentència basada en una condició particular. Es basa en avaluar el valor true o false en les declaracions `if-else i if-elseif`. **AWK** admet tot tipus de sentències condicionals com altres llenguatges de programació.

Implementeu una comanda que us indiqui quins pokemons de tipus foc són ordinaris o llegendaris. Busquem una sortida semblant a:

```bash
Charmander is a common pokemon.
Charizard is a legendary pokemon.
 ...
```

La condició per ser un pokémon llegendari és que la columna 13 sigui **True**.

```bash
awk -F, '/Fire/ { if ($13 == "True") { print $2, "is a legendary pokemon." } else { print $2, "is a common pokemon." } }' pokemon.csv
```

Es pot simplificar la comanda anterior amb l'ús de l'operador ternari **?:**:

```bash
awk -F, '/Fire/ { print $2, "is a", ($13 == "True" ? "legendary" : "common"), "pokemon." }' pokemon.csv
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
        
        if ($7 > max){  
            pmax=$2  
            max=$7  
        }  
        if ($7 < min){  
            pmin=$2
            min=$7  
        }  
    }  
}  
END{ printf("Avg(Attack):%4.2f \nWeakest:%s \nStrongest:%s\n",attack/n,pmin,pmax)
}' pokemon.csv 
```

### Exercicis Intermedis

* Implementeu un script que compti tots els pokemons que tenim a la pokedex i que tingui la sortida següent:

    ```bash
    Counting pokemons...
    There are 800 pokemons.
    ```

    Recordeu que la primera línia és la capçalera i no la volem comptar.

  * En bash:

    ```bash
    !/bin/bash
    echo "Counting pokemons..." 
    ~n=`wc -l pokemon.csv` 
    ~n=`expr $n - 1`
    echo "There are $n pokemons."
    ```

  * En **AWK**:

    ```bash
    ~awk 'BEGIN { print "Counting pokemons..." } { ++n } END{ print "There are ", n-1, "pokemons." }' pokemon.csv
    ```

* Implementeu un comptador per saber tots els pokemons de tipus foc de la primera generació descartant els Mega pokemons i que tingui la sortida següent:

    ```bash
    Counting pokemons...
    There are 12 fire type pokemons in the first generation without Mega evolutions.
    ```

  * Per fer-ho en bash, podeu combinar les comandes **grep, cut, wc** i **expr**. Nota, l'argyment **-v** de **grep** exclou les línies que contenen el patró i la generació s'indica a la columna 12 amb el valor 1:

    ```bash
    !/bin/bash
    echo "Counting pokemons..."
    ~n=`grep Fire pokemon.csv | grep -v "Mega" | cut -d, -f12 | grep 1 | wc -l`
    ~n=`expr $n - 1`
    echo "There are $n pokemons in the first generation without Mega evolutions."
    ```

    * Per fer-ho en **AWK**, teniu el negador **!** per negar el patró:

    ```bash
    ~awk -F, 'BEGIN { print "Counting pokemons..." } /Fire/ && !/Mega/ && $12 == 1 { ++n } END{ print "There are ", n, "fire type pokemons in the first generation without Mega evolutions." }' pokemon.csv
    ```

    En aquest exemple, hem utilitzat l'operador lògic **&&** per combinar dos patrons. Això significa que la línia ha de contenir el patró **Fire** i no ha de contenir el patró **Mega**. Això ens permet filtrar els Mega pokemons del nostre comptador. A més, hem utilitzat l'operador **!** per negar el patró **Mega**. Això significa que la línia no ha de contenir el patró **Mega**. Finalment, hem utilitzat la clàusula **{END}** per imprimir el resultat final.

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
    ~while IFS=, read -r col1 col2 col3 rest; do
    ~((line_number++))
    ~# Check if the line contains the word "Fire"
    ~if [[ "$col2" == *"Fire"*  || "$col3" == *"Fire"* ]]; then
    ~    echo "Line: $line_number    $col2"
    ~fi
    ~done < pokemon.csv
    ```

* Implementeu un script que permeti comptar el nombre de pokemons de tipus foc i drac. La sortida ha de ser semblant a:

    ```bash
    Fire:64
    Dragon:50
    Others:689
    ```

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

    ~while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13; do
     ~if [[ "$col3" == *"Fire"*  || "$col4" == *"Fire"* ]]; then
         ~((fire++))
     ~fi

     ~if [[ "$col3" == *"Dragon"*  || "$col4" == *"Dragon"* ]]; then
         ~((dragon++))
     ~fi
     
     ~if [[ "$col3" != *"Fire"*  && "$col4" != *"Fire"* && "$col3" != *"Dragon"*  && "$col4" != *"Dragon"* ]]; then
         ~((others++))
     ~fi
    ~done < pokemon.csv

    echo "Fire:$fire"
    echo "Dragon:$dragon"
    echo "Others:$others"
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
    ~while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13; do
    ~if [[ "$col1" == "#" ]]; then
    ~    echo "$col1,$col2,$col3,$col4,$col5,$col6,$col7,$col8,$col9,$col10,$col11,$col12,$col13,Avg"
    ~else
        ~avg=$((($col6+$col7+$col8+$col9+$col10+$col11)/6))
        ~echo "$col1,$col2,$col3,$col4,$col5,$col6,$col7,$col8,$col9,$col10,$col11,$col12,$col13,$avg"
    ~fi
    ~done < pokemon.csv
    ```

    **Nota**: Bash de forma nativa no permet operacions aritmètiques amb nombres decimals. Per fer-ho, cal utilitzar una eina com `bc`. En aquest cas, podeu adaptar el codi per utilitzar `bc` quan calculeu la mitjana i fer servir `printf` per formatar la sortida amb el nombre de decimals que vulgueu.

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
    ~while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13; do
    ~if [[ "$col3" == *"Fire"* ]] && [[ "$col12" == "1" ]]; then
    ~    if [[ "$col7" -gt "$max" ]]; then
    ~    max=$col7
    ~    pmax=$col2
    ~    fi
    ~    if [[ "$col7" -lt "$min" ]]; then
    ~    min=$col7
    ~    pmin=$col2
    ~    fi
    ~fi
    ~done < pokemon.csv
    echo "Weakest: $pmin"
    echo "Strongest: $pmax"
    ```
