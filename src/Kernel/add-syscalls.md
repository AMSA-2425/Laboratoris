# Afegint una crida a sistema

Per afegir una nova crida a sistema, cal configurar la **taula de crides a sistema**. Aquesta taula és una estructura de dades que relaciona els números de crida al sistema amb les funcions de controlador de sistema corresponents. Quan un programa realitza una crida a sistema, s'utilitza aquesta taula per determinar quina funció de controlador s'ha d'executar.

La taula de crides a sistema es troba normalment a un fitxer anomenat *syscall_ARCH.tbl*, en aquest cas **syscall_64.tbl** per a l'arquitectura *x86*, a la ruta *arch/x86/entry/syscalls/*.

```sh
less /root/linux-6.11.1/arch/x86/entry/syscalls/syscall_64.tbl
```

Aquest fitxer enumera totes les crides a sistema disponibles, assignant un número únic a cadascuna. Per exemple, la crida a sistema associada amb **write** té el número 1 i **fork** té el número 57.

```sh
grep -i "write" /root/linux-6.11.1/arch/x86/include/generated/asm/syscalls_64.h

grep -i "fork" /root/linux-6.11.1/arch/x86/include/generated/asm/syscalls_64.h
```

Aquesta numeració és essencial per garantir la coherència entre l'espai d'adreces d'usuari i l'espai d'adreces del kernel. La UAPI (User-space API) fa referència a un sistema per mantenir aquesta coherència, assegurant que els números de crida al sistema a l'espai d'adreces de l'usuari coincideixin amb els del kernel.

Diferents arquitectures poden utilitzar diferents números de crida al sistema per a la mateixa funcionalitat. Per exemple, el número de crida a sistema per a **fork** és 2 en arquitectures Intel x86 de 32 bits, mentre que és 57 en arquitectures Intel x86 de 64 bits.

Un cop es realitza una crida a sistema en un nucli en execució, el nucli cerca la funció de controlador d'aquesta crida al sistema a la taula de crides del sistema. Aquesta taula és una matriu on l'índex és el número de crida al sistema i el valor és el punter a la funció de controlador corresponent (*sys_call_ptr_t*).

A la nostra configuració, el codi font de la taula de crides del sistema és la matriu anomenada **sys_call_table** definida a *arch/x86/entry/syscall_64.c*. Aquest fitxer s'inicialitza des del fitxer *arch/x86/include/generated/asm/syscalls_64.h*, que es genera automàticament mitjançant **syscall_64.tbl** quan es recompila el nucli.

```sh
less /root/linux-6.11.1/arch/x86/entry/syscall_64.c
```

La taula de crides a sistema es troba a *arch/x86/entry/syscalls/syscall_64.tbl*. Aquest fitxer conté una llista de totes les crides a sistema disponibles. Aquest fitxer no és codi font C, però s'utilitza per produir fitxers de codi font C **generats** com ara *arch/x86/include/generated/asm/syscalls_64.h* durant el procés de recompilar del nucli.

```sh
less /root/linux-6.11.1/arch/x86/include/generated/asm/syscalls_64.h
```

A continuació, es mostra un exemple per afegir una crida a sistema anomenada *sys_getdummymul*. Aquesta crida a sistema donats dos números enters en mode usuari els passarà a mode nucli i els multiplicarà en el nucli. Un cop acabada l'operació, ens retornarà el seu resultat en mode usuari.

1. Actualitzar la taula de crides a sistema. Per fer-ho, afegirem una nova entrada a **syscall_64.tbl** amb el número de la nova crida a sistema i el seu nom, com ara *sys_getdummymul*. El número de la nsotra crida serà el següent enter disponible a la taula de crides a sistema.

    Per exemples si l'última crida a sistema té l'índex 451, la nostra crida tindrà l'índex 452.

    ```sh
    vim /root/linux-6.11.1/arch/x86/entry/syscalls/syscall_64.tbl
    ```

    En aquest fitxer cerqueu el final de la secció *common* i afegiu la vostra crida a sistema. El format és el següent:

    ```sh
    <index> <abi> <name> <entry point>
    ```

    Per tant, en el nostre cas:

    ```sh
    452 common getdummymul sys_getdummymul
    ```

    Un cop modificat el fitxer, deseu-lo i tanqueu-lo.

2. Definir la funció del controlador. Ara definirem el contracte de la nostra funció de controlador. Aquesta funció s'ha de definir a *kernel/sys.c*.

    ```sh
    vim /root/linux-6.11.1/include/linux/syscalls.h
    ```

    Afegiu la següent línia al final del fitxer. Recordeu prement (*majuscula + G*) podeu anar al final del fitxer.

    ```sh
    asmlinkage long sys_getdummymul(int num1, int num2, int* resultat);
    ```

    Aquesta funció rep dos enters i un punter a un enter. Els dos enters són els dos números que volem multiplicar i el punter a enter és on volem que es guardi el resultat de la multiplicació.

3. Implementar la funció del controlador. Ara implementarem la funció de controlador. Aquesta funció s'ha de definir a *kernel/sys.c*.

    ```sh
    vim /root/linux-6.11.1/kernel/sys.c
    ```

    Afegiu al final del fitxer el codi C:

    ```c
    SYSCALL_DEFINE3(getdummymul,int, num1, int ,num2, int*, resultat){
        printk("Estic al kernel executant getdummymul syscall!\n");
        int res = num1 * num2;
        printk("El resultat de multiplicar num1=%d i num2=%d es res=%d (Mode kernel)\n", num1,num2,res);
        copy_to_user(resultat, &res, sizeof(int));
        return 0;
    }
    ```

    Aquesta funció utilitza **printk** per escriure un missatge al registre del nucli. Aquest missatge el podrem recuperar en mode usuari per monitoritzar la correcta execució de la funció en mode nucle. A continuació, multiplica els dos enters i utilitza **copy_to_user** per copiar el resultat al punter a enter que li hem passat com a paràmetre. Finalment, retorna 0.

    Es molt important utilitzar el **copy_to_user** per copiar el resultat al punter a enter que li hem passat com a paràmetre. Si no ho fem així, el resultat de la multiplicació no es copiarà a l'espai d'adreces de l'usuari i no podrem recuperar el resultat de la multiplicació.

    Recordeu que l'espai d'adreçes del nucli i del usuari són diferents, per tant la informació s'ha de copiar de l'espai d'adreces del nucli a l'espai d'adreces de l'usuari i viceversa. Compte, quan l'usuari passa un punter com a parametre les funcions del nucli sempre han de comprovar que apunti a una regió vàlida de l'espai d'adreces de l'usuari.

4. Actualitzar l'espai d'adreces de l'usuari. En aquest pas, ens hem d'assegurar que en l'espai d'adreces de l'usuari hi ha una definició de la crida que acabem d'implementar. Per fer-ho editarem */root/linux-6.11.1/include/uapi/asm-generic/unistd.h*.

    ```sh
    vim /root/linux-6.11.1/include/uapi/asm-generic/unistd.h
    ```

    Cerca la línia: __NR_syscalls (quasi al final del fitxer)

    ```c
    //Editeu la línia augmentant en 1 el valor que tingueu. En el meu cas 449 -> 450:
    #define __NR_syscalls 452

    //Just damunt de la línia anterior -> afegim:
    #define __NR_getdummymul 453
    __SYSCALL(__NR_getdummymul, sys_getdummymul)
    ```

    Deseu i tanqueu el fitxer.

    En aquesta modificació hem actualitzat el nº de criada a sistema i hem afegit la nostra crida a sistema en l'espai d'adreçament de l'usuari.

5. Per acabar recompileu el kernel i reinicieu la màquina virtual.

    ```sh
    make -j `nproc` && make modules_install -j `nproc` && make install -j `nproc`
    reboot
    ```

Per comprovar que la nostra crida a sistema funciona, crearem un programa amb C que faci anar la nostra crida a sistema:

```c
#include<stdio.h>
#include<unistd.h>
#include <stdlib.h>
#include<sys/syscall.h>
// Posar el nº de crida a sistema que hem definit a syscall_64.tbl
#define __NR_getdummymul ???

int main(){
    int num1 = 4;
    int num2 = 3; 
    int resultat;
    syscall(__NR_getdummymul, num1,num2, &resultat);
    printf("(Mode usuari) El resultat de la multiplicacio es: %d\n", resultat);    
}
```

Compilem el programa i l'executem:

```sh
gcc getdummymul.c -o getdummymul
./getdummymul
```

Podem utiltizar la comanda **strace** per veure les crides a sistema que fa el nostre programa:

```sh
stracte ./getdummymul   
```

## Activitats de seguiment

1. Genereu un document en format markdown amb les captures de pantalla per demostrar el funcionament de la nova crida a sistema. **Podeu editar add-syscall.md del repositori**.
