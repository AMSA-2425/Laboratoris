# Awk - Avançat

## Variables definides quan executem AWK

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

## Bucles

El llenguatge **AWK** també ens permet fer bucles accepta les següents estructures:

* `for (expr1;expr2;expr3) { acció }`: Aquest bucle executa la primera expressió, després avalua la segona expressió i si és certa executa l'acció. Després executa la tercera expressió i torna a avaluar la segona expressió. Això es repeteix fins que la segona expressió sigui falsa.

Per exemple, transformeu el fitxer `pokemon.csv` en un fitxer amb els camps separats per **;** utilitzant un bucle **for**:

```bash
awk -F, \
BEGIN{OFS=";";}
{  
for (i=1;i<=NF;i++)  
    printf("%s%s",$i,(i==NF)?"\n":OFS)
}' pokemon.csv
```

* `while (condició) { acció }`: Aquest bucle executa l'acció mentre la condició sigui certa.

Per exemple, substituïu els camps del tipus de pokemon per un camps tipus compost per els dos tipus de pokemon separats per un **/** dels primers 10 pokemons:

```bash
awk -F, \
'BEGIN{OFS=",";}
{
while (NR>1 && NR <= 11) {
    print $1, $2, $3 "/" $4, $5, $6, $7, $8, $9, $10, $11, $12, $13
    getline
}
}' pokemon.csv
```

La comanda `getline` ens permet llegir la següent línia de l'entrada. Això ens permet llegir la següent línia dins del bucle **while**. Si no fem servir la comanda `getline`, el bucle **while** es quedaria en un bucle infinit ja que la condició `NR <= 11` sempre seria certa.

* `do { acció } while (condició)`: Aquest bucle executa l'acció una vegada i després avalua la condició. Si la condició és certa, torna a executar l'acció.

Per exemple, utilitzeu el bucle **do** per comptar el nombre de pokemons de tipus foc:

```bash
awk -F, \
'BEGIN{print "Counting pokemons..."; n=0}  
{
do {  
    if ($3 == "Fire" || $4 == "Fire")  
        n++  
} while (getline)  
}  
END{print "There are ", n, "fire type pokemons."}' pokemon.csv
```

Instruccions de control:

* `break`: Finalitza el bucle actual.
* `continue`: Salta a la següent iteració del bucle.
* `next`: Salta a la següent línia de l'entrada.

Per exemple:


* Cerqueu la primera entrada que compleixi les següents condicions: el tipus de pokemon és "Fire" i la seva velocitat és més gran que 100:

    ```bash
    awk -F, 'BEGIN {found = 0} { if (found == 0) { for (i=1; i<=NF; i++) { if ($i == "Fire" && $7 > 100) { print "El primer Pokémon de tipus Fire amb velocitat superior a 100 és: " $2; found = 1; break } } } }' pokemon.csv
    ```

    Observació: `break` finalitza el bucle actual que recorre els camps de la línia. Per tant, ens permet deixar de buscar en una línia quan ja hem trobat el que volem. 

* Cerqueu totes les entrades que compleixen les següents condicions: el tipus de pokemon és "Fire" i la seva velocitat és més gran que 100:

    ```bash
    awk -F, '{ for (i=1; i<=NF; i++) { if ($i == "Fire" && $7 > 100) { print $2 } } }' pokemon.csv
    ```

    o bé

    ```bash
    awk -F, '{ for (i=1; i<=NF; i++) { if ($i == "Fire" && $7 > 100) { print $2; break } } }' pokemon.csv
    ```

    Observació: `break` ens permet que quan trobem un pokemon que compleix les condicions, no cal seguir buscant en la mateixa línia i podem passar a la següent. En aquest cas, `next` seria equivalent a `break`.

* Cerqueu tots els pokemons que són voladors i de foc assumint que les columnes poden estar en qualsevol ordre i que cada entrada pot estar ordenada de forma diferent:

    ```bash
    awk -F, '{ for (i=1; i<=NF; i++) { if ($i == "Fire") { for (j=1; j<=NF; j++) { if ($j == "Flying") { print $2; next } } } } }' pokemon.csv
    ```

    Observació: `next` ens permet que quan trobem un pokemon que compleix les condicions, no cal seguir buscant en la mateixa línia i podem passar a la següent.

    Observació: `break` ens donaria el mateix resultat en aquest cas. Però `next` és més eficient perquè no cal seguir recorrent els camps de la línia. La comanda `break` seguiria recorrent els camps al bucle de la variable **i**.

## Arrays

**AWK** també ens permet fer servir arrays. Per exemple, podem fer servir un array per comptar el nombre de pokemons de cada tipus:

```bash
awk -F, '
{
    if (NR > 1) {
        type1 = $3
        type2 = $4
        types[type1]++
        if (type2 != "") {
            types[type2]++
        }
    }
}
END {
    for (type in types) {
        print type, types[type]
    }
}' pokemon.csv
```

Els arrays en **AWK** són associatius, és a dir, no cal indicar la posició de l'element en l'array. Per exemple, si volem comptar el nombre de pokemons de cada tipus per generació:

```bash
awk -F, '
{
    if (NR > 1) {
        type1 = $3
        type2 = $4
        gen = $12
        types[type1][gen]++
        if (type2 != "") {
            types[type2][gen]++
        }
    }
}
END {
    for (type in types) {
        printf "%s\n", type
        for (gen in types[type]) {
            printf "  Gen %d: %d\n", gen, types[type][gen]
        }
    }
}' pokemon.csv
```

## Exercicis Avançats AWK

1. Implementeu un script que mostri la pokedex en ordre invers. Però mantenint la primera línia com a capçalera. 

    ```bash
    awk -F, '
    {
    ~    if (NR == 1) {
    ~        print $0
    ~    } else {
    ~        lines[NR] = $0
    ~    }
    }
    END {
    ~    for (i = NR; i > 1; i--) {
    ~        print lines[i]
    ~    }
    }' pokemon.csv
    ```

2. Implementeu un script que simuli la comanda `sort -t, -k5 -n pokemon.csv`. Aquesta comanda ordena el fitxer pokemon.csv pel camp Total de forma numèrica. Podeu fer servir la funció `asort` per ordenar els pokemons. Aquesta funció ordena un array i retorna el nombre d'elements de l'array ordenat. Per exemple:

    ```bash
    asort(array, sorted, "@val_num_asc")
    ```
  
    ordena l'array **array** de forma numèrica ascendent i guarda el resultat a l'array **sorted**.

    A més, podeu fer servir la funció `split` que ens permet dividir una cadena de text en un array. Per exemple:

    ```bash
    split("a,b,c,d", array, ",")
    ```

    divideix la cadena de text "a,b,c,d" en l'array **array** amb els valors "a", "b", "c" i "d".

    ```bash
    awk -F, '
    {
        ~if (NR == 1) {
        ~    print $0
        ~} else {
        ~    lines[NR] = $0
        ~    totals[NR] = $5 " " NR
        ~}
    }
    END {
        ~n = asort(totals, sorted, "@val_num_asc")
        ~for (i = 1; i <= n; i++) {
        ~    split(sorted[i], temp, " ")
        ~    line = temp[2]
        ~    print lines[line]
        }
    }' pokemon.csv
    ```

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
    {
        ~if(NR == 1) {
            ~for (i = 2; i <= NF; i++) {
                ~headers[i] = $i
            ~}
        ~}
        ~else {
            ~if(NR != 2) {
            ~    print "  },"
            ~}
            ~printf "  {\n"
            ~for (i = 2; i <= NF; i++) {
            ~    if ($i ~ /^[0-9]+$/) {
            ~        printf "    \"%s\": %d,\n", headers[i], $i
            ~    } else {
            ~        printf "    \"%s\": \"%s\",\n", headers[i], $i
            ~    }
            ~}
        ~}
    }
    END {
        ~print "  }\n]"
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
    pokemon1=$1
    pokemon2=$2

    # Function to get stats of a pokemon
    ~get_stats() {
    ~    awk -F, -v pokemon="$1" '$2 == pokemon { print $6, $7, $8, $9, $10, $11 }' pokemon.csv
    ~}

    # Get the stats of the pokemons
    ~stats1=$(get_stats $pokemon1)
    ~stats2=$(get_stats $pokemon2)

    # Extract the stats
    ~read hp1 attack1 defense1 spatk1 spdef1 speed1 <<< $stats1
    ~read hp2 attack2 defense2 spatk2 spdef2 speed2 <<< $stats2

    # Check who attacks first
    ~if [ $speed1 -gt $speed2 ]; then
    ~    attacker=$pokemon1
    ~    hp=$hp2
    ~    defender=$pokemon2
    ~    attack=$attack1
    ~    defense=$defense2
    ~else
    ~    attacker=$pokemon2
    ~    defender=$pokemon1
    ~    hp=$hp1
    ~    attack=$attack2
    ~    defense=$defense1
    ~fi

    ~echo "$attacker attacks first!"

    # Start the battle
    while true; do
    ~    damage=$((($attack - $defense) * $RANDOM / 32767))
    ~    damage=${damage#-}
    ~    hp=$(($hp - $damage))
    ~    echo "$attacker attacks $defender with $damage damage!"
    ~    if [ $hp -le 0 ]; then
    ~        echo "$defender has 0 HP left."
    ~        echo "$defender fainted!"
    ~        break
    ~    else
    ~        echo "$defender has $hp HP left."
    ~    fi

         # Swap the attacker and defender
    ~    tmp=$attacker
    ~    attacker=$defender
    ~    defender=$tmp
    ~    tmp=$hp
    ~    hp=$hp2
    ~    hp2=$tmp
    ~    tmp=$attack
    ~    attack=$attack2
    ~    attack2=$tmp
    ~    tmp=$defense
    ~    defense=$defense2
    ~    defense2=$tmp
    done
    ```
