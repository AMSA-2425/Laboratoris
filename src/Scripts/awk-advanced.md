# Awk - Avançat


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