# Bash

En aquest laboratori repassarem els conceptes bàsics de Bash, el llenguatge de programació de scripts més utilitzat en sistemes GNU/Linux. Aquest laboratori està enfocat en repassar els conceptes bàsics que vau estudiar en l'assignatura de Sistemes Operatius.

## Contextualització

En aquest laboratori crearem una aplicació per gestionar una llista de pokemons. Aquesta aplicació haurà de permetre afegir, llistar, eliminar i buscar pokemons. A més a més, haureu de fer servir un fitxer per emmagatzemar la informació dels pokemons.

## Preparació

- **Entorn de treball**: Màquina virtual amb una distribució GNU/Linux instal·lada pot ser Debian o AlmaLinux.

## Objectius

- Repassar els conceptes bàsics de Bash.

## Tasques

1. Creeu un esquelet pel vostre script Bash.

    ```bash
    #!/bin/bash

    # Constants

    # Functions

    # Main

    return 0
    ```

2. Implementeu una constant `POKEDEX_FILE` amb el nom del fitxer on emmagatzemareu la informació dels pokemons.

    ```bash
    POKEDEX_FILE="pokedex.txt"
    ```

3. Implementeu un menu amb la sintaxi `case` que permeti executar les següents comandes: `help`, `list`, `search`, `delete` i `new`.

    ```bash
    case $1 in
        help)
            pokedex_help
            ;;
        list)
            pokedex_list
            ;;
        search)
            pokedex_search $2
            ;;
        delete)
            pokedex_delete $2
            ;;
        new)
            pokedex_new $2 $3 $4 $5 $6 $7
            ;;
        *)
            echo "Comanda no trobada."
            pokedex_help
            ;;
    esac
    ```

4. Implementeu la funció `pokedex_help` que mostri per pantalla les instruccions d'ús del script.

    ```bash
    function pokedex_help() {
        echo "Ús: ./pokedex.sh <comanda> <arguments>"
        echo "Comandes:"
        echo "  list: Llistar pokemons"
        echo "  search <name>: Buscar pokemon"
        echo "  delete <name>: Eliminar pokemon"
        echo "  new <name> <type> <hp> <attack> <defense> <speed>: Afegir pokemon"
    }
    ```

5. Implementeu la funció `pokedex_list` que llegeixi el fitxer `POKEDEX_FILE` i mostri per pantalla la llista de pokemons.

    - Podeu fer servir la comanda `cat` per llegir el fitxer `POKEDEX_FILE`.

    ```bash
    function pokedex_list() {
        cat $POKEDEX_FILE
    }
    ```

    - Assegureu-vos que existeix el fitxer `POKEDEX_FILE`.

    ```bash
    if [[ ! -f $POKEDEX_FILE ]]; then
        echo "El fitxer $POKEDEX_FILE no existeix."
        return 1
    fi
    ```

6. Implementeu la funció `pokedex_search <name>` que llegeixi el fitxer `POKEDEX_FILE` i mostri per pantalla la informació del pokemon amb nom `<name>`.

    - Podeu fer servir la comanda `grep` per buscar el pokemon amb nom `<name>`.

    ```bash
    function pokedex_search() {
        grep $1 $POKEDEX_FILE
    }
    ```

    - Assegureu-vos que la funció `pokedex_search` rep un argument.

    ```bash
    if [[ -z $1 ]]; then
        echo "Has d'indicar el nom del pokemon."
        echo "Ús: ./pokedex.sh search <name>"
        return 1
    fi
    ```

7. Implementeu la funció `pokedex_delete <name>` que elimini el pokemon amb nom `<name>` del fitxer `POKEDEX_FILE`.

    - Podeu fer servir la comanda `sed` per eliminar el pokemon amb nom `<name>`.

    ```bash
    function pokedex_delete() {
        sed -i "/$1/d" $POKEDEX_FILE
    }
    ```

    - Assegureu-vos que la funció `pokedex_delete` rep un argument.

    ```bash
    if [[ -z $1 ]]; then
        echo "Has d'indicar el nom del pokemon."
        echo "Ús: ./pokedex.sh delete <name>"
        return 1
    fi
    ```

8. Implementeu la funció `pokedex_new <name> <type> <hp> <attack> <defense> <speed>` que permet afegir un nou pokemon a la pokedex.

    - Podeu fer servir la comanda `echo` per afegir el nou pokemon al fitxer `POKEDEX_FILE`.

    ```bash
    function pokedex_new() {
        echo "$1 $2 $3 $4 $5 $6" >> $POKEDEX_FILE
    }
    ```

    - Assegureu-vos que la funció `pokedex_new` rep tots els arguments necessaris.

    ```bash
    if [[ -z $1 || -z $2 || -z $3 || -z $4 || -z $5 || -z $6 ]]; then
        echo "Has d'indicar el nom, tipus, hp, attack, defense i speed del pokemon."
        echo "Ús: ./pokedex.sh new <name> <type> <hp> <attack> <defense> <speed>"
        return 1
    fi
    ```
