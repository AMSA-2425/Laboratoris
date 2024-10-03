# Programació de mòduls

En aquest laboratori aprendrem a programar mòduls per al kernel de Linux. Aquesta és una de les tasques més complexes que es poden fer en el món de la programació de sistemes. Per això, realitzarem uns exemples senzills per a entendre com es programen els mòduls i com es poden integrar al kernel.

## Requisits previs

Per a realitzar aquest laboratori, necessitarem tenir instal·lat un sistema Debian amb els paquets necessaris per a la construcció de programari. Aquests paquets són els linux-headers corresponents a la versió del kernel:

```bash
su -c "apt install linux-headers-$(uname -r) -y"
```

* **libncurses-dev**: Biblioteca de desenvolupament per a la creació d'aplicacions amb interfície de text.
* **bison**: Generador d'anàlisi sintàctica.
* **flex**: Generador d'anàlisi lèxica.
* **kmod**: Eina per a la gestió de mòduls del kernel.

## Mòduls del Kernel

Els **mòduls** són fragments de codi que es poden carregar i descarregar al nucli de forma dinàmica. Ens permeten ampliar la funcionalitat del nucli sense necessitat de reiniciar el sistema.

> **Nota**: Sense mòduls, hauríem de construir nuclis **monolítics** i afegir noves funcionalitats directament a la imatge del nucli. A més de tenir nuclis més grans, amb l'inconvenient d'exigir reconstruir i reiniciar el nucli cada vegada que volem una nova funcionalitat.

1. Obtenir informació sobre la versió del kernel actual:

    ```bash
    uname -r
    ```

    En el meu cas, la versió del kernel és `6.1.0-25-arm64`.

2. Per veure els mòduls carregats al kernel, podem fer servir la comanda `lsmod`:

    ```bash
    su -c "lsmod"
    ```

    També podem fer servir la comanda `cat` per llegir el fitxer `/proc/modules`:

    ```bash
    su -c "cat /proc/modules"
    ```

    Si volem filtrar un mòdul concret, podem fer servir la comanda `grep`:

    ```bash
    su -c "lsmod | grep fat"
    ```

Els moduls del kernel registren la informació de log en una consola, però per defecte no la podreu veure per la sortida estàndard (sdtout) o la sortida d'error (stderr). Per veure aquesta informació, necessitarem fer servir la comanda `dmesg`.

Per exemple, si volem veure els últims missatges del kernel, podem fer servir la comanda:

```bash
su -c "dmesg | tail -n 10"
```

Aquest missatge provenen dels mòduls del kernel que utilitzen la funció `printk` per imprimir informació de log. Aquesta funció permet especificar el nivell de log  i el mòdul que genera el missatge. Per canviar el nivell de log, podem fer servir la comanda `dmesg` amb l'opció `-n`:

```bash
su -c "dmesg -n 4"
```

En aquest cas, el nivell de log és 4, que correspon a `WARNING`. Això significa que només es mostraran els missatges de log amb nivell `WARNING` o superior.

Nivells de log disponibles:

* 0: `KERN_EMERG`: Missatges d'emergència.
* 1: `KERN_ALERT`: Missatges d'alerta.
* 2: `KERN_CRIT`: Missatges crítics.
* 3: `KERN_ERR`: Missatges d'error.
* 4: `KERN_WARNING`: Missatges d'avís.
* 5: `KERN_NOTICE`: Missatges de notificació.
* 6: `KERN_INFO`: Missatges d'informació.
* 7: `KERN_DEBUG`: Missatges de depuració.
* 8: `KERN_DEFAULT`: Nivell per defecte.

## Programant un mòdul

En aquesta secció, programarem un mòdul senzill per al kernel de Linux. Aquest mòdul imprimirà un missatge d'inici i un missatge de finalització quan es carregui i descarregui al kernel.

1. Creem un directori per al nostre mòdul:

    ```bash
    mkdir -p $HOME/kernel
    cd $HOME/kernel
    ```

2. Creem un fitxer anomenat `hello.c` amb el següent contingut:

    ```c
    #include <linux/kernel.h>
    #include <linux/module.h> 

    MODULE_LICENSE("GPL");

    int init_module(void) {
        printk(KERN_INFO "Hello, world!\n");
        return 0;
    }

    void cleanup_module(void) {
        printk(KERN_INFO "Goodbye, world!\n");
    }
    ```

3. Crearem un fitxer `Makefile` per compilar el nostre mòdul amb el següent contingut:

    ```makefile
    CONFIG_MODULE_SIG=n
    obj-m += hello.o

    all:
        make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

    clean:
        make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
    ```

    > **Nota**:
    >
    > * El fitxer `Makefile` és sensible a la indentació. Assegureu-vos que utilitzeu tabuladors en lloc d'espais.
    > * La variable `obj-m` indica quin és el mòdul que volem compilar.
    > * La variable `PWD` conté la ruta del directori actual.
    > * `$(shell uname -r)` retorna la versió del kernel actual.
    > * `CONFIG_MODULE_SIG=n` desactiva la verificació de la signatura del mòdul.

4. Compil·lem el nostre mòdul amb la comanda `make`:

    ```bash
    make
    ```

    > **Troubleshooting**:
    >
    > * Si obteniu un error de `missing separator`, assegureu-vos que utilitzeu tabuladors en lloc d'espais.
    > * Si obteniu un error de `/lib/modules/`, assegureu-vos que teniu instal·lat el paquet `linux-headers`.
    > * Si obteniu un error de `missing MODULE_LICENSE()`, podeu afegir la següent línia al vostre fitxer `hello.c`:

5. Carreguem el nostre mòdul amb la comanda `insmod`:

    ```bash
    su -
    insmod /home/jordi/laboratoris/lab2-kernel/kernel-modules/hello.ko
    ```

    > **Nota**: Si teniu errors assegureu-vos que esteu executant la comanda com a `root`. Quan canviem a l'usuari `root`, la variable `$HOME` canvia a `/root`. Per tant, assegureu-vos d'apuntar a la ruta correcta.


6. Comprovem que el mòdul s'ha carregat correctament amb la comanda `lsmod`:

    ```bash
    lsmod | grep hello
    ```

    Si el mòdul s'ha carregat correctament, veureu una sortida similar a aquesta:

    ```bash
    hello                 16384  0
    ```

7. Comprovem els missatges del kernel amb la comanda `dmesg`:

    ```bash
    su -c "dmesg"
    ```

    Si tot ha anat bé, veureu els missatges `Hello, world!` al final de la sortida.

8. Descarreguem el mòdul amb la comanda `rmmod`:

    ```bash
    rmmod hello
    ```

9. Comprovem que el mòdul s'ha descarregat correctament amb la comanda `lsmod`:

    ```bash
    lsmod | grep hello
    ```

    Si el mòdul s'ha descarregat correctament, hauríeu de veure el missatge `Goodbye, world!` al final de la sortida de `dmesg`.

Es poden fer diferents millores i moduls més complexos, però aquest és un exemple senzill per a començar a programar mòduls per al kernel de Linux. Per exemple, podeu afegir més informació al mòdul com llicència, autor, descripció i versió. També podeu utilitzar les macros `__init` i `__exit` per optimitzar el mòdul i reduir la memòria utilitzada.

Per exemple, aquí teniu un exemple millorat del mòdul `hello.c`:

```c
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Jordi Mateo");
MODULE_DESCRIPTION("Hello World OS Kernel Module");
MODULE_VERSION("0.1");

static int __init hello_init(void) {
    printk(KERN_INFO "WOW I AM A KERNEL HACKER!!!\n");
    return 0;
}

static void __exit hello_cleanup(void) {
    printk(KERN_INFO "I am dead.\n");
}

module_init(hello_init);
module_exit(hello_cleanup);
```

## Exercicis

1. Creeu un mòdul que imprimeixi la informació sobre el procés actual. Podeu fer servir la `task_struct` per obtenir la informació del procés actual. Podeu imprimir la informació del PID, el nom del procés, i la memòria utilitzada.

    ```c
    #include <linux/init.h>
    #include <linux/module.h>
    #include <linux/kernel.h>
    #include <linux/sched.h>

    MODULE_LICENSE("GPL");
    MODULE_DESCRIPTION("Process Info Kernel Module");
    MODULE_VERSION("0.1");

    static int __init process_info_init(void) {
       

        return 0;
    }

    static void __exit process_info_cleanup(void) {
        printk(KERN_INFO "Process Info module unloaded.\n");
    }

    module_init(process_info_init);
    module_exit(process_info_cleanup);
    ```
