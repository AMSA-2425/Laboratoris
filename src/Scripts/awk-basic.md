# Awk - Bàsic


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
