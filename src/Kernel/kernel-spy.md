# Espiant el Kernel

En aquest laboratori us proposo utiltzar el programa `strace` per espiar el comportament del kernel. Aquesta eina ens permetrà veure les crides a sistema que es fan des d'un programa en execució. Això ens permetrà entendre com interactuen els programes amb el sistema operatiu.

## Preparació

1. Accediu a la màquina virtual Debian i instal·leu el paquet `strace`:

    ```bash
    su -c "apt install strace -y"
    ```

## `strace`

**[Strace](https://strace.io/)** és una eina que permet monitoritzar i fer un seguiment de les crides al sistema que realitza un programa.

* Quines crides a sistema utilitza el procés?
* Quins fitxers esta utilitzant l'aplicació?
* Quins arguments es passen a les crides a sistema?
* Quines crides a sistema estan fallant, i per què?

El seu funcionament es basa en la crida a sistema `ptrace`, que permet a un procés monitoritzar i controlar un altre procés.

Per comenzar a utilitzar `strace`, simplement executa la comanda següent:

```bash
strace cat /dev/null
```

Aquest exemple mostra totes les crides a sistema realitzades pel programa `cat`, que en aquest cas, no fa res perquè `/dev/null` és un fitxer buit.

Si volem filtrar per crides específiques, podem fer-ho així:

```bash
strace -e trace=close cat /dev/null
```

En aquest cas, només veurem les crides `close` que fa el programa `cat`.

Si volem filtrar per crides que comencin per un patró, podem fer-ho així:

```bash
strace -e trace=/get* ls
```

Aquest exemple mostra totes les crides que comencin per `get` que fa el programa `ls`.

Per guardar la sortida en un fitxer, podem fer-ho així:

```bash
strace -o strace.log -e trace=open,close ls
```

Això desarà totes les crides `open` i `close` en un fitxer anomenat `strace.log`.

Si necessitem excloure una crida a sistema en particular, com `gettimeofday`, podem fer-ho així:

```bash
strace -o strace.log -e trace!=gettimeofday ls
```

Per filtrar per categories de crides a sistema, podem fer-ho així:

```bash
strace -o strace.log -e trace=%{X} ls
```

On `{X}` representa la categoria que t'interessa.

Els filtres a `strace` es poden classificar en diverses categories per facilitar la depuració i l'anàlisi:

* `%file`: Inclou totes les crides a sistema que impliquen fitxers com a arguments.
* `%desc`: Comprèn les crides a sistema relacionades amb descriptors de fitxers.
* `%process`: Inclou les crides a sistema que gestiona processos.
* `%network`: Inclou les crides a sistema relacionades amb la xarxa.
* `%signal`: Inclou les crides a sistema que gestionen senyals.
* `%memory`: Inclou les crides a sistema que es relacionen amb la gestió de la memòria.
* `%ipc`: Inclou les crides a sistema relacionades amb la comunicació interprocessual.
* `%fs`: Inclou les crides a sistema relacionades amb el sistema de fitxers.
* `%all`: Inclou totes les crides a sistema.

Per exemple, si volem veure totes les crides a sistema relacionades amb la xarxa, podem fer-ho així:

```bash
strace -o strace.log -e trace=%network ls
```

Addicionalment, `strace` ens permet obtenir un resum de les crides a sistema que fa un programa. Per exemple, si volem veure un resum de les crides a sistema que fa `cat`, podem fer-ho així:

```bash
strace -c cat /dev/null
```

## Exemple: `strace` amb un Hola Món

El següent programa C escriu un missatge a la sortida estàndard i finalitza:

```c
#include <stdio.h>  // printf
#include <stdlib.h> // exit

#define STR "HELLO\n"

int main(int argc, char *argv[]) {
    printf("%s", STR);
    exit(0);          
}
```

1. Compileu el programa:

    ```bash
    gcc hola.c -o hola 
    ```

2. Executeu el programa amb `strace`:

    ```bash
    strace -o hola.log ./hola
    ```

3. Consulteu el fitxer `hola.log` per veure les crides a sistema que fa el programa `hola`.

    ```bash
    less hola.log
    ```

### Analitzant la sortida

1. La primera línia ens mostra la crida a sistema `execve` que s'ha fet per executar el programa `hola`. Quan es crea un nou procés a Linux `fork()`, el fill és idèntic al pare. Llavors, `execv()` substitueix el procés actual (fill) pel programa `hola.c`. Aquest efecte s'anomena **recobriment**. Com veurem més endavant, aquesta crida a sistema és la que ens permet executar un nou programa.
2. La segona línia ens mostra la crida a sistema `brk` que ens permet ajustar el límit superior de l'heap, permetent al programa sol·licitar més memòria dinàmica. L'adreça retornada marca el límit actual de l'heap.
3. La tercera línia ens mostra la crida a sistema `mmap` que ens permet mapejar una regió de memòria. En aquest cas, el programa `hola` mapeja una regió de memòria de 8192 bytes amb permisos de lectura i escriptura. Aquesta memòria s'utilitza per emmagatzemar dades temporals durant l'execució del programa. Ens mostra l'adreça on s'ha mapejat la regió de memòria.
4. La quarta línia ens mostra la crida a sistema `faccessat` que ens permet comprovar si un fitxer es pot llegir. En aquest cas, el programa `hola` intenta llegir el fitxer `/etc/ld.so.preload`, però com que no existeix, la crida retorna `ENOENT` (El fitxer o directori no existeix).

    > Nota:
    > Tots els programes intenten obrir `/etc/ld.so.preload`, aquest comportament està integrat a Glibc. Normalment `/etc/ld.so.preload` no existeix, així que cada procés només crida `access`, rep una resposta negativa i segueix endavant.

5. La cinquena línia ens mostra la crida a sistema `openat` que ens permet obrir un fitxer. En aquest cas, el programa `hola` intenta obrir el fitxer `/etc/ld.so.cache` en mode lectura. El valor de retorn és 3, que és el descriptor de fitxer que s'ha obert.
6. La sisena línia ens mostra la crida a sistema `newfstatat` que ens permet obtenir informació sobre un fitxer com ara el seu estat, propietari, permisos, últim accés, etc. El valor de retorn ens indica que la crida ha estat satisfactòria.
7. La setena línia ens mostra la crida a sistema `mmap` que ens permet mapejar una regió de memòria. En aquest cas, mapeja una regió de memòria de 20870 bytes amb permisos de lectura. Això es fa perquè el programa necessita llegir la informació del fitxer `/etc/ld.so.cache`. El valor de retorn ens indica l'adreça on s'ha mapejat la regió de memòria.
8. La vuitena línia ens mostra la crida a sistema `close` que ens permet tancar un fitxer. En aquest cas, `/etc/ld.so.cache`. El valor de retorn ens indica que la crida ha estat satisfactòria. I el descriptor de fitxer 3 ja no està disponible.
9. Per fer servir la llibreria `libc.so.6` que conté la implementació de les funcions bàsiques del llenguatge C, aquesta ha de ser carregada a la memòria. Els passos són els següents:
   1. La crida a sistema `openat` obre la llibreria `libc.so.6` en mode lectura. El valor de retorn és 3, que és el descriptor de fitxer que s'ha obert.
   2. La crida a sistema `read` llegeix 832 bytes de la llibreria `libc.so.6`. El valor de retorn ens indica que s'han llegit 832 bytes. Aquesta informació és la capçalera que té format ELF.
   3. La crida a sistema `newfstatat` ens permet obtenir informació sobre la llibreria `libc.so.6`.
   4. La crida a sistema `mmap` mapeja una regió de memòria de 1826912 bytes amb permisos de lectura.
   5. La crida a sistema `mmap` mapeja una regió de memòria de 1761376 bytes amb permisos d'execució. Aquesta memòria es fa servir per executar la llibreria `libc.so.6`. El valor de retorn ens indica l'adreça on s'ha mapejat la regió de memòria.
   6. Les crides `munmap` alliberen regions de memòria que ja no es fan servir. En aquest cas, la llibreria `libc.so.6` ja no necessita llegir la capçalera ELF.
   7. La crida a sistema `mprotect` canvia els permisos d'una regió de memòria a *PROT_NONE* (sense permisos). Aquesta regió de memòria ja no es fa servir.
   8. Les crides `mmap` mapegen dos regions de memòria de 24576 i 49248 bytes amb permisos de lectura i escriptura per emmagatzemar dades temporals durant l'execució de la llibreria `libc.so.6`. El valor de retorn ens indica les adreces on s'han mapejat les regions de memòria (0xffff833bc000 i 0xffff833c2000).
   9. La crida a sistema `close` tanca la llibreria `libc.so.6`. El valor de retorn ens indica que la crida ha estat satisfactòria. I el descriptor de fitxer 3 ja no està disponible.

    > No comentarem les crides a sistema `set_tid_address`, `set_robust_list`, `rseq`, `prlimit64`, `getrandom` ja que no són rellevants per aquest exemple i les veurem més endavant.

10. Les següents crides a sistema `mprotect` canvien els permisos a *PROT_READ* (només lectura) de diferents regions de memòria. La primera regió de memòria és de 16384 bytes, la segona de 4096 bytes i la tercera de 8192 bytes.
11. La crida a sistema `newfstatat` ens permet obtenir informació sobre la sortida estàndard. Fixeu-vos que el descriptor de fitxer és 1. L'objectiu del programa en C es mostrar el missatge `HELLO` per la sortida estàndard.
12. Les crides `brk(NULL)` i `brk(0xaaaadad16000)` primer obtenen l'adreça final de la pila i després ajusten el límit superior de l'heap. Es a dir, el programa augmenta la mida de l'heap per emmagatzemar la cadena `HELLO\n` abans d'escriure-la per la sortida estàndard.

    > Nota: Tot i que no s'utiltiza la memòria dinàmica de forma explícita, la crida a sistema `write(1, "HELLO\n", 6)` fa servir la memòria dinàmica per emmagatzemar la cadena `HELLO\n` abans d'escriure-la per la sortida estàndard. Podeu comprovar-ho si mirem la implementació de la funció `printf` de la llibreria `libc.so.6`.
  
13. La crida a sistema `write` escriu 6 caràcters a la sortida estàndard. En aquest cas, el programa `hola` escriu la cadena `HELLO\n` per la sortida estàndard. El valor de retorn ens indica que s'han escrit 6 caràcters.
14. La crida a sistema `exit_group` finalitza el programa `hola`. El valor de retorn és 0, que indica que el programa ha finalitzat correctament.

    > Nota: La crida a sistema `exit_group` és la que s'utilitza per finalitzar un procés. Aquesta crida finalitza tots els fils del procés i allibera tots els recursos que s'han utilitzat. Si observeu el manual de la crida a sistema `exit` (`man 2 exit`), veureu que aquesta crida invoca la crida a sistema del kernel amb el mateix nom. Des de la versió 2.3 de Glibc, la funció `exit` invoca la crida a sistema `exit_group` per tal de finalitzar tots els fils d'un procés.

## Exercici Opcional: `strace` amb un programa que obre un fitxer

1. Creeu un fitxer anomenat `open.c` amb el següent codi:

    ```c
    int main(int argc, char *argv[]) {
        int fd;
        if (argc != 2) {
            fprintf(stderr, "Usage: %s <file>\n", argv[0]);
            exit(1);
        }
        fd = open(argv[1], O_RDONLY);
        if (fd == -1) {
            perror("open");
            exit(1);
        }
        close(fd);
        return 0;
    }
    ```

    Aquest programa obre un fitxer en mode lectura i el tanca. Si no es passa cap argument, mostra un missatge d'ús.

2. Compileu el programa:

    ```bash
    gcc -o open open.c
    ```

3. Executeu el programa amb `strace`:

    ```bash
    strace -o open_1.log ./open /etc/passwd
    ```

4. Executeu el programa amb `strace`:

    ```bash
    strace -o open_2.log ./open /etc/shadow
    ```

Obriu els fitxers `open_1.log` i `open_2.log` amb un editor de text o amb la comanda `less` i analitzeu el seu comportament i les diferències entre ells. Escriu un informe amb llenguatge Markdown on expliqueu les diferències entre els dos fitxers de log i afegiu una taula resum amb el num de crides a sistema que fa cada programa. **Podeu utiltizar el fitxer open.md del repositori**.
