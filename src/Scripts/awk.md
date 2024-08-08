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
