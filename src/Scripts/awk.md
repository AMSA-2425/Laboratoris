# Introducció al llenguatge AWK

## Objectius

* Entendre la sintaxi bàsica d'**AWK**.
* Aprendre a utilitzar **AWK** per processar fitxers de text.
* Entendre les diferències entre **AWK** i **BASH**.

## Prerequisits

* Una màquina virtual amb sistema operatiu Linux, preferiblement AlmaLinux 9.4. Es recomana accedir a la màquina virtual mitjançant SSH.

## Què és AWK?

**AWK** és un llenguatge de programació potent i versàtil, dissenyat específicament per a l’anàlisi de patrons i el processament de text. La seva funció principal és processar fitxers de text de manera eficient, permetent la transformació de dades, la generació d’informes i la filtració de dades.

Pràcticament tots els sistemes Unix disposen d’una implementació d’AWK. Això inclou sistemes operatius com GNU/Linux, macOS, BSD, Solaris, AIX, HP-UX, entre d’altres. Per verificar si tens AWK instal·lat al teu sistema, pots utilitzar la comanda`awk --version`.

**AWK** es caracteritza per ser compacte, ràpid i senzill, amb un llenguatge d’entrada net i comprensible que recorda al llenguatge de programació C. Disposa de construccions de programació robustes que inclouen `if/else, while, do/while`, entre d’altres. L’eina AWK processa una llista de fitxers com a arguments. En cas de no proporcionar fitxers, AWK llegeix de l’entrada estàndard, permetent així la seva combinació amb *pipes* per a operacions més complexes.

## Utilització de l'eina AWK

Pots trobar tota la informació sobre el funcionament de l’eina **AWK** a la pàgina de manual. Per exemple, per obtenir informació sobre la comanda awk, pots utilitzar la comanda `man awk`. Aquesta comanda et proporcionarà tota la informació necessària per utilitzar l’eina AWK.

* Pots utilitzar l’eina amb el codi escrit directament *acció-awk* a la línia de comandes o combinada en un script:

    ```sh
    awk [-F] '{acció-awk}' [ fitxer1 ... fitxerN ]
    ```

* També pots utilitzar l’eina amb tota la sintaxi awk guardada en un fitxer script-awk des de la línia de comandes o combinada amb altres scripts:
  
    ```sh
    awk [-F] -f script-awk [ fitxer1 ... fitxerN ]
    ```

En aquests exemples, [-F] és una opció que permet especificar el caràcter delimitador de camps, **{acció-awk}** és el codi AWK que vols executar, i *[ fitxer1 ... fitxerN ]* són els fitxers d’entrada que AWK processarà. Si no s’especifica cap fitxer, AWK llegirà de l’entrada estàndard.

## Fitxer de Dades d'Exemple per utilitzar en aquest Laboratori

En aquest laboratori, farem servir un fitxer de dades específic com a conjunt de dades d’exemple. Aquest fitxer representa una pokedex i es pot obtenir amb la següent comanda:

```bash
curl -O https://gist.githubusercontent.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6/raw/92200bc0a673d5ce2110aaad4544ed6c4010f687/pokemon.csv
```

Aquest fitxer conté 801 línies (800 pokemons + 1 capçalera) i 13 columnes. Les columnes són les següents:

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

Per comprovar aquestes dades, podem fer servir les següents comandes:

* Utilitzeu la comanda `wc` per comptar el nombre de línies del fitxer:

    ```bash
    ~wc -l pokemon.csv
    ```

* Utilitzeu la comanda `head` per mostrar les primeres 10 línies del fitxer:

    ```bash
    ~head pokemon.csv
    ```

* Utilitzeu les comandes `wc` i `head` per comptar el nombre de columnes del fitxer. Recordeu que les columnes estan separades per comes:

    ```bash
    ~head -1 pokemon.csv | tr ',' '\n' | wc -l
    ```

## Estrucutra Bàsica d'AWK

El llenguatge **AWK** s'organitza amb duples de la forma `patró { acció }`. El patró pot ser una expressió regular o una condició lògica. L’acció és el que es vol realitzar amb les línies que compleixen el patró. Per tant, AWK processa els fitxers línia per línia. Per cada línia del fitxer, AWK avalua el patró. Si el patró és cert, executa l’acció. Si el patró és fals, passa a la següent línia.


Per exemple, si volem imprimir totes les línies d'un fitxer (**acció**) que contenten una expressió regular definida a *regex* (**patró**), podem fer servir la següent sintaxi:

```bash
awk '/regex/ { print }' fitxer
```

Observeu que utilitzem el caràcter `/` per indicar que el patró és una expressió regular.

A més, AWK ens permet utilitzar una estructura de control `BEGIN` i `END`. La clàusula `BEGIN` s'executa abans de processar qualsevol línia i la clàusula `END` s'executa després de processar totes les línies. Aquestes clausules són *opcionals* i no són necessàries en tots els casos.

```bash
BEGIN { acció }
patró { acció }
END { acció }
```

Per exemple, si volem indicar que estem començant a processar un fitxer, podem fer servir la clàusula `BEGIN`. I si volem indicar que hem acabat de processar el fitxer, podem fer servir la clàusula `END`. A continuació, teniu un exemple de com utilitzar les clàusules `BEGIN` i `END`:

```bash
awk '
    BEGIN { print "Començant a processar el fitxer..." } 
    /regex/ { print }
    END { print "Finalitzant el processament del fitxer..." }
' fitxer
```

## Aprenent a utilitzar AWK amb Exemples

### Sintaxis Bàsica

En aquesta secció veurem com podem utiltizar AWK per substituir algunes comandes bàsiques de bash com `cat, grep, cut`.

#### `cat`

La comanda `cat` ens permet mostrar el contingut d'un fitxer. Per exemple, per mostrar el contingut del fitxer pokemon.csv:

```bash
cat pokemon.csv
```

Podem fer servir **AWK** per fer el mateix. Per exemple, per mostrar el contingut del fitxer pokemon.csv:

```bash
awk '{print}' pokemon.csv
```

on `{print}` és l'acció que volem realitzar. En aquest cas, volem imprimir totes les línies del fitxer. Això és equivalent a la comanda `cat`.

AWK també ens permet acompanyar l'acció amb variables. Per exemple, la variable **$0** conté tota la línia. Per tant, podem utilitzar la variable **$0** per imprimir totes les línies del fitxer:

```bash
awk '{print $0}' pokemon.csv
```

**Nota**: AWK processa els fitxers línia per línia. Per cada línia del fitxer, **AWK** avalua l'acció. Es a dir, amb la comanda `awk '{print $0}' pokemon.csv` estem indicant que per cada línia del fitxer, imprimeixi la línia sencera. Per tant, aquesta comanda és equivalent a la comanda `cat`.

Podeu comparar les sortides de les comandes `cat` i `awk` per assegurar-vos que són les mateixes utilitzant la comanda `diff`:

```bash
~diff <(cat pokemon.csv) <(awk '{print $0}' pokemon.csv)
```

#### `grep`

La comanda `grep` ens permet cercar patrons en un fitxer. Per exemple, per mostrar totes les línies que contenen la paraula "Char" al fitxer pokemon.csv:

```bash
grep Char pokemon.csv
```

Podem fer servir **AWK** per fer el mateix. Per exemple, per mostrar totes les línies que contenen la paraula "Char" al fitxer pokemon.csv:

```bash
awk '/Char/ {print}' pokemon.csv
```

on `/Char/` és el patró que volem cercar. Per tant, tenim un patró de cerca i una acció a realitzar. En aquest cas, estem cercant linia per linia la paraula "Char" i si la trobem, imprimim tota la línia. Això és equivalent a la comanda `grep`.

Una confusió  comuna es pensar que l'expressió `/Char/` indica que la línia comença per "Char". Això no és cert. L'expressió `/Char/` indica que la línia conté la paraula "Char". Per exemple, podem buscar totes les línies del fitxer pokemon.csv que contenen el patró "ois":

```bash
~awk '/ois/ {print}' pokemon.csv
```

En la sortida, veureu que tant les paraules "poison" del tipus de pokémon com els diferents noms de pokémon que contenen la paraula "ois" són mostrats.

 ```bash
1,Bulbasaur,Grass,Poison,318,45,49,49,65,65,45,1,False
9,Blastoise,Water,-,530,79,83,100,85,105,78,1,False
...
71,Victreebel,Grass,Poison,490,80,105,65,100,70,70,1,False
...
691,Dragalge,Poison,Dragon,494,65,75,90,97,123,44,6,False
```

Conteu quantes línies compleixen aquest patró, combinant **AWK** amb la comanda `wc`:

```bash
~awk '/ois/ {print}' pokemon.csv | wc -l
```

En aquest cas, hi ha 64 entrades que satisfan aquest patró.

#### `cut`

La comanda `cut` ens permet extreure columnes d'un fitxer. Per exemple, per mostrar només la primera columna del fitxer pokemon.csv:

```bash
cut -d, -f1 pokemon.csv
```

on `-d,` indica que el separador de camps és la coma i `-f1` indica que volem la primera columna. Podem fer servir **AWK** per fer el mateix. Per exemple, per mostrar només la primera columna del fitxer pokemon.csv:

```bash
awk -F, '{print $1}' pokemon.csv
```

on `-F,` indica que el separador de camps és la coma i `{print $1}` indica que volem la primera columna. Això és equivalent a la comanda `cut`.

Cada item separat pel separador de camps es denomina camp. Per exemple, en el fitxer pokemon.csv, cada columna separada per una coma és un camp. Per defecte, el separador de camps és l'espai en blanc. Per tant, si no especifiquem el separador de camps, **AWK** utilitzarà l'espai en blanc com a separador de camps.

Si intentem imprimir la tercera columna sense especificar el separador de camps, la sortida no serà correcta:

```bash
awk '{print $3}' pokemon.csv
```

Això és degut a que el separador de camps per defecte és l'espai en blanc i no la coma. Ara bé, si modifiquem el separador de camps a l'espai en blanc, enlloc de la coma, podem obtenir la sortida correcta:

```bash
sed 's/,/ /g' pokemon.csv | awk '{print $3}'
```

En aquest cas, estem substituint totes les comes per espais en blanc i després utilitzant **AWK** per imprimir la tercera columna.

### Verificacions lògiques

Es pot utilitzar com a patró una expressió composta amb operadors i retornar *true* o *false*.

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

Per utilizar aquestes expressions, podem fer servir la següent sintaxi:

```bash
awk 'patró { acció }' fitxer
```

on el patró és una expressió composta amb operadors lògics i l'acció és el que es vol fer amb les línies que compleixen el patró. Per exemple:

* Mostrar tots els pokemons que tenen més de 100 punts d'atac (valor de la columna 7):

    ```bash
    awk -F, '$7 > 100 {print}' pokemon.csv
    ```

* Mostrar tots els pokemons que tenen més de 100 punts d'atac (valor de la columna 7) i són de la primera generació (valor de la columna 12):

    ```bash
    awk -F, '$7 > 100 && $12 == 1 {print}' pokemon.csv
    ```

* Mostrar tots els pokemons que tenen més de 100 punts d'atac (valor de la columna 7) o són de la primera generació (valor de la columna 12):

    ```bash
    awk -F, '$7 > 100 || $12 == 1 {print}' pokemon.csv
    ```

* Mostrar tots els pokemons que són Mega pokemons (contenen la paraula "Mega" a la columna 2):

    ```bash
    awk -F, '$2 ~ /Mega/ {print}' pokemon.csv
    ```

* Mostra tots els pokemons que no són Mega pokemons (no contenen la paraula "Mega" a la columna 2):

    ```bash
    awk -F, '$2 !~ /Mega/ {print}' pokemon.csv
    ```

### Exercicis Bàsics

Aquests exercicis estan resolts en bash i en **AWK**. Podeu provar-los en el vostre sistema per entendre com funcionen. Intenta resoldre primer els exercicis en **bash** i després en **AWK**. Un cop pensada la solució, podeu comparar-la amb la solució proporcionada.

1. Implementeu una comanda que permeti filtrar tots els pokemon de tipus foc (Foc) i imprimir únicament per *stdout* el nom i els seus tipus (columnes 2, 3 i 4).

    * En bash podem fer servir la comanda **grep** per filtrar les línies que contenen la paraula "Fire" i la comanda **cut** per extreure les columnes 2, 3 i 4:

    ```bash
    grep Fire pokemon.csv | cut -d, -f2,3,4
    ```

    * En **AWK**:

    ```bash
    ~awk -F, '/Fire/ {print $2,$3,$4}' pokemon.csv
    ```

2. Implementeu una comanda que permeti imprimir totes les línies que continguin una **'b'** o una **'B'** seguida de **"ut"**. Mostra només el nom del pokémon (columna 2).

    * En **AWk** podem fer servir l'expressió regular **[bB]ut**:

    ```bash
    ~awk -F, '/[bB]ut/ {print $2}' pokemon.csv
    ```

    * En bash podem fer servir la comanda **grep** amb l'argument **-i** per ignorar la diferència entre majúscules i minúscules:

    ```bash
    ~grep -i "but" pokemon.csv | cut -d, -f2
    ```

3. Implementeu una comanda que permeti imprimir totes les línies que comencin per un **"K"** majúscula. Mostra només el nom del pokémon (columna 2).

    * En **bash** podem fer servir la comanda **grep** amb el meta caràcter **^** per indicar que la línia comença per "K" majúscula:

    ```bash
    ~grep "^K" pokemon.csv | cut -d, -f2
    ```

    * En **AWK**:

    ```bash
    ~awk -F, '$2 ~ /^K/ {print $2}' pokemon.csv
    ```

    **!Compte:** Per defecte, les expressions regulars actuen sobre tota la línia **$0**. Si voleu aplicar l'expressió regular a una columna determinada, necessiteu l'operador (**~**). Si intenteu aplicar:
    `awk -F,'/^K/ {print $2}' pokemon.csv` no funcionarà ja que l'inici **^** de **$0** serà un enter.

4. Imprimiu tots els pokemons que siguin del tipus foc o lluita. Imprimiu el nom, tipus 1 i tipus 2. Podeu fer servir l'operador **|** per crear l'expressió regular.

   * En **AWK** podem fer servir l'operador **|** per combinar dos patrons:

    ```bash
    ~awk -F, '/Fire|Fighting/ {print $2,$3,$4}' pokemon.csv
    ```

    * En bash, podeu fer servir l'argument **-E** per utilitzar expressions regulars exteses amb la comanda **grep**:

    ```bash
    ~grep -E "Fire|Fighting" pokemon.csv | cut -d, -f2,3,4
    ```

5. Imprimiu tots els pokemons que siguin del tipus foc i lluita. Imprimiu el nom, tipus 1 i tipus 2. Podeu fer servir l'operador **&&** per crear l'expressió regular.

   * En **AWK** podem fer servir l'operador **&&** per combinar dos patrons:

    ```bash
    ~awk -F, '/Fire/ && /Fighting/ {print $2,$3,$4}' pokemon.csv
    ```

   * En bash, podeu fer servir l'argument **-E** per utilitzar expressions regulars exteses amb la comanda **grep**:

    ```bash
    ~grep -E "Fire.*Fighting|Fighting.*Fire" pokemon.csv | cut -d, -f2,3,4
    ```

    En aquest cas no podem fer servir l'operador **&&** ja que **grep** no permet aquesta funcionalitat. Per tant, hem de fer servir l'operador **|** per combinar els dos patrons. A més, hem de fer servir l'expressió regular **Fire.*Fighting|Fighting.*Fire** per indicar que volem les línies que contenen "Fire" seguit de "Fighting" o "Fighting" seguit de "Fire".

6. Imprimiu el nom de tots els pokemons de la primera generació que siguin llegendaris. Per fer-ho utilitzeu les columnes 12 i 13. La columna 12 indica la generació amb valors númerics (1,2,3,...) i la columna 13 indica si un pokémon és llegendari o no (0: No, 1: Sí).

    * En **AWK** podem fer servir l'operador **&&** per combinar dos patrons:

    ```bash
    ~awk -F, '$12 == 1 && $13 == "True" {print $2}' pokemon.csv
    ```

    * En bash, podem fer servir la comanda **grep** per filtrar les línies que contenen la primera generació i són llegendaris i la comanda **cut** per extreure la columna 2:

    ```bash
    ~grep "1,True" pokemon.csv | cut -d, -f2
    ```

    Aquesta solució no és la més òptima, ja que es podria donar el cas que altres columnes continguessin la paraula "1,True". Per solucionar-ho podem fer un script més complex que comprovi que la columna 12 conté el valor 1 i la columna 13 conté la paraula "True".

    ```bash
    #!/bin/bash
    ~while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13; do
    ~if [[ "$col12" == "1" ]] && [[ "$col13" == "True" ]]; then
    ~    echo "$col2"
    ~fi
    ~done < pokemon.csv
    ```

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
    ~while IFS=, read -r col1 col2 rest; do
    ~((line_number++))
    ~# Check if the line contains the word "Fire"
    ~if [[ "$col1" == *"Fire"* ]]; then
    ~    echo "Line: $line_number    $col2"
    ~fi
    ~done < pokemon.csv
    ```

* Implementeu un script que permeti comptar el nombre de pokemons de tipus foc i drac. La sortida ha de ser semblant a:

    ```bash
    Fire:12  
    Dragon:3  
    Others:136
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
     ~if [[ "$col3" == *"Fire"* ]]; then
         ~((fire++))
     ~elif [[ "$col3" == *"Dragon"* ]]; then
         ~((dragon++))
     ~else
         ~((others++))
     ~fi
    ~done < pokemon.csv
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
    ~    echo "$col1,$col2,$col3,$col4,$col5,$col6,$col7,$col8,$col9,$col10,$col11,$col12,$col13,$((col6+col7+col8+col9+col10+col11))/6"
    ~fi
    ~done < pokemon.csv
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

Per exemple:

* Transformeu el fitxer pokemon.csv en un fitxer amb els camps separats per tabulacions:

    ```bash
    awk -F, 'BEGIN{OFS="\t"} {print $0}' pokemon_tab.csv
    ```

* Per fer servir el fitxer pokemon_tab.csv podem utilitzar els mateixos scripts que hem fet servir amb el fitxer pokemon.csv. Però indicant que el separador de camps és un tabulador. Per exemple, per comptar el nombre de pokemons lluitadors:

    ```bash
    awk -F"\t" '/Fighting/ {print $2}' pokemon_tab.csv
    ```

* Si volem fer servir una variable entorn per indicar el tipus de pokemons que volem comptar, podem fer-ho així:

    ```bash
    ~awk -F"\t" -v type=$TYPE '{ if ($3 == type) { print $2 } }' pokemon_tab.csv
    ```

    on **$TYPE** és una variable entorn que conté el tipus de pokemons que volem comptar.

### Bucles

El llenguatge **AWK** també ens permet fer bucles accepta les següents estructures:

* `for (expr1;expr2;expr3) { acció }`: Aquest bucle executa la primera expressió, després avalua la segona expressió i si és certa executa l'acció. Després executa la tercera expressió i torna a avaluar la segona expressió. Això es repeteix fins que la segona expressió sigui falsa.

* `while (condició) { acció }`: Aquest bucle executa l'acció mentre la condició sigui certa.

* `do { acció } while (condició)`: Aquest bucle executa l'acció una vegada i després avalua la condició. Si la condició és certa, torna a executar l'acció.

Per exemple:

* Implementeu un script que ens mostri el nom dels pokemons de tipus foc:

    ```bash
    awk -F, '{ for (i=1;i<=NF;i++) if ($3 == "Fire") print $2 }' pokemon.csv
    ```

    on **NF** és el nombre de camps de la línia. En fitxers ben estructurats no té sentit, ja que sabem que el tipus de pokemon és a la tercera columna i podem simplificar la comanda:

    ```bash
    awk -F, '{ if ($3 == "Fire") print $2 }' pokemon.csv
    ```

    però en fitxers més complexos i desordenats ens pot ser útil.

* Transformeu el fitxer pokemon.csv en un fitxer amb els camps separats per **;** utilitzant un bucle **for**:

    ```bash
    awk -F, \
    'BEGIN{OFS=";";}
    {  
    for (i=1;i\<=NF;i++)  
        printf("%s%s",$i,(i==NF)?"\\n":OFS)
    }' pokemon.csv
    ```

* Utilitzeu el bucle **do**, **while** per comptar el nombre de pokemons de tipus foc:

    ```bash
    awk -F, \
    'BEGIN{print "Counting pokemons..."; n=0}  
    {  
    do {  
        if ($3 == "Fire")  
            n++  
    } while (getline)  
    }  
    END{print "There are ", n, "fire type pokemons."}' pokemon.csv
    ```

### Exercicis Avançats AWK

1. Implementeu un script que mostri una taula resum amb els pokemons de cada tipus a cada generació. Un exemple de la sortida esperada:

    | Tipus      | Gen 1 | Gen 2 | Gen 3 | Gen 4 | Gen 5 | Gen 6 |
    |------------|-------|-------|-------|-------|-------|-------|
    | Normal     | 24    | 15    | 18    | 18    | 19    | 8     |
    | Dragon     | 4     | 2     | 15    | 8     | 12    | 9     |
    | Ground     | 14    | 11    | 16    | 12    | 12    | 2     |
    | Electric   | 9     | 9     | 5     | 12    | 12    | 3     |
    | Poison     | 36    | 4     | 5     | 8     | 7     | 2     |
    | Steel      | 2     | 6     | 12    | 12    | 12    | 5     |
    | Bug        | 14    | 12    | 14    | 11    | 18    | 3     |
    | Grass      | 15    | 10    | 18    | 17    | 20    | 15    |
    | Fire       | 14    | 11    | 9     | 6     | 16    | 8     |
    | Dark       | 1     | 8     | 13    | 7     | 16    | 6     |
    | Ice        | 5     | 5     | 7     | 8     | 9     | 4     |
    | Fighting   | 9     | 4     | 9     | 10    | 17    | 4     |
    | Water      | 35    | 18    | 31    | 15    | 18    | 9     |
    | Ghost      | 4     | 1     | 8     | 9     | 9     | 15    |
    | Flying     | 23    | 19    | 14    | 16    | 21    | 8     |
    | Rock       | 12    | 8     | 12    | 7     | 10    | 9     |
    | Fairy      | 5     | 8     | 8     | 2     | 3     | 14    |
    | Psychic    | 18    | 10    | 28    | 10    | 16    | 8     |

    Notes:

    1. Els tipus de pokemons es troben a la columna 3 i 4 i la generació a la columna 12.
    2. Utilitzeu printf per formatar la sortida.

   * En **AWK**:

    ```bash
    awk -F, '
    BEGIN {
        print "| Tipus      | Gen 1 | Gen 2 | Gen 3 | Gen 4 | Gen 5 | Gen 6 |"
        print "|------------|-------|-------|-------|-------|-------|-------|"
    }
    {
    ~    if (NR > 1) {
    ~        type1 = $3
    ~        type2 = $4
    ~        gen = $12
    ~        types[type1][gen]++
    ~        if (type2 != "") {
    ~            types[type2][gen]++
            }
        } 
    }
    END {
        ~for (type in types) {
        ~    printf "| %-10s |", type
        ~    for (gen = 1; gen <= 6; gen++) {
        ~        printf " %-5s |", types[type][gen] ? types[type][gen] : 0
        ~    }
        ~    print ""
        }
    }' pokemon.csv
    ```

2. Implementeu un parser que transformi el fitxer `pokemon.csv` en un fitxer `pokemon.json`. Aquest fitxer ha de ser formatat de forma correcta. Podeu assumir que coneixeu els headers del fitxer i la tipologia de les seves dades. Per exemple, la primera línia del fitxer pokemon.csv ha de ser transformada en:

    ```json
    {
        "Name": "Bulbasaur",
        "Type 1": "Grass",
        "Type 2": "Poison",
        "Total": 318,
        "HP": 45,
        "Attack": 49,
        "Defense": 49,
        "Sp. Atk": 65,
        "Sp. Def": 65,
        "Speed": 45,
        "Generation": 1,
        "Legendary": false
    }
    ```

    * Una solució simple en **AWK**:

    ```bash
    awk -F, '
    BEGIN {
        ~print "["
    }
    {
        ~if (NR > 1) {
        ~    printf "  {\n"
        ~    printf "    \"Name\": \"%s\",\n", $2
        ~    printf "    \"Type 1\": \"%s\",\n", $3
        ~    printf "    \"Type 2\": \"%s\",\n", $4
        ~    printf "    \"Total\": %d,\n", $5
        ~    printf "    \"HP\": %d,\n", $6
        ~    printf "    \"Attack\": %d,\n", $7
        ~    printf "    \"Defense\": %d,\n", $8
        ~    printf "    \"Sp. Atk\": %d,\n", $9
        ~    printf "    \"Sp. Def\": %d,\n", $10
        ~    printf "    \"Speed\": %d,\n", $11
        ~    printf "    \"Generation\": %d,\n", $12
        ~    printf "    \"Legendary\": %s\n", $13
        ~    printf "  }%s\n", (NR == 800) ? "" : ","
        ~}
    }
    END {
        ~print "]"
    }' pokemon.csv > pokemon.json
    ```

    * Una solució més complexa en **AWK**:

    ```bash
    awk -F, '
    BEGIN {
        ~print "["
    }
    ~NR == 1 {
    ~    for (i = 2; i <= NF; i++) {
    ~        headers[i] = $i
    ~    }
    ~}
    {
    ~    printf "  {\n"
    ~    for (i = 2; i <= NF; i++) {
    ~        if ($i ~ /^[0-9]+$/) {
    ~            printf "    \"%s\": %d,\n", headers[i], $i
    ~        } else {
    ~            printf "    \"%s\": \"%s\",\n", headers[i], $i
    ~        }
    ~    }
    ~    printf "  }%s\n", (NR == 1) ? "" : ","
    }
    END {
    ~    print "]"
    }' pokemon.csv > pokemon.json
    ```

3. Implementeu un script que permeti simular un combat entre dos pokémons. Els pokémons es passen com a variables d'entorn i han d'utilitzar el nom del pokémon a la pokedex. La lògica del combat és comparar els valors de velocitat per saber qui ataca primer. El pokémon que ataca primer és el que té més velocitat. Si els dos pokémons tenen la mateixa velocitat, el primer pokémon que s'ha passat com a variable d'entorn ataca primer. El combat es fa de forma alternada fins que un dels dos pokémons es queda sense punts de vida. El dany es mesura com (Atac - Defensa) multiplicat per un valor aleatori entre 0 i 1. Aquest es resta a la vida del pokémon oponent. La sortida ha de ser semblant a:

    ```bash
    Charizard attacks first!
    Charizard attacks Charmander with 50 damage!
    Charmander has 20 HP left.
    Charmander attacks Charizard with 30 damage!
    Charizard has 70 HP left.
    Charizard attacks Charmander with 40 damage!
    Charmander has -10 HP left.
    Charmander fainted!
    ```

    * Una possible solució combinar **AWK** i **bash**:

    ```bash
    #!/bin/bash

    # Get the pokemons from the command line arguments
    ~pokemon1=$1
    ~pokemon2=$2

    # Get the stats of the pokemons
    ~stats1=$(awk -F, -v pokemon="$pokemon1" '$2 == pokemon { print $6, $7, $8, $9, $10, $11 }' pokemon.csv)
    ~stats2=$(awk -F, -v pokemon="$pokemon2" '$2 == pokemon { print $6, $7, $8, $9, $10, $11 }' pokemon.csv)

    # Extract the stats
    ~read hp1 attack1 defense1 spatk1 spdef1 speed1 <<< $stats1
    ~read hp2 attack2 defense2 spatk2 spdef2 speed2 <<< $stats2

    # Check who attacks first
    ~if [ $speed1 -gt $speed2 ]; then
    ~    attacker=$pokemon1
    ~    defender=$pokemon2
    ~else
    ~    attacker=$pokemon2
    ~    defender=$pokemon1
    ~fi

    echo "$attacker attacks first!"

    # Start the battle
    while true; do
        ~damage=$((($attack1 - $defense2) * $RANDOM / 32767))
        ~if [ $damage -lt 0 ]; then
        ~    damage=0
        ~fi
        ~hp2=$(($hp2 - $damage))
        ~echo "$attacker attacks $defender with $damage damage!"
        ~if [ $hp2 -le 0 ]; then
        ~    echo "$defender has 0 HP left."
        ~    echo "$defender fainted!"
        ~    break
        ~else
        ~    echo "$defender has $hp2 HP left."
        ~fi

        # Swap the attacker and defender
        ~tmp=$attacker
        ~attacker=$defender
        ~defender=$tmp
        ~tmp=$hp1
        ~hp1=$hp2
        ~hp2=$tmp
        ~tmp=$attack1
        ~attack1=$attack2
        ~attack2=$tmp
        ~tmp=$defense1
        ~defense1=$defense2
        ~defense2=$tmp
        ~tmp=$spatk1
        ~spatk1=$spatk2
        ~spatk2=$tmp
        ~tmp=$spdef1
        ~spdef1=$spdef2
        ~spdef2=$tmp
        ~tmp=$speed1
        ~speed1=$speed2
        ~speed2=$tmp
    done
    ```

### Activitat

Heu d’incorporar al repositori cinc exemples diferents, ordenats de menor a major complexitat. Cada exemple ha de ser únic i ha d’incloure una explicació detallada del que fa el codi, així com versions tant en bash com en AWK. Si l’exemple que tenies pensat ja ha estat implementat per un company, hauràs de buscar-ne un de nou. Per tant, és recomanable que revisis els exemples que ja han publicat els teus companys abans de publicar els teus propis exemples
