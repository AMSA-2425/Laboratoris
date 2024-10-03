# Analitzant les crides a sistema

Les crides a sistema són la interfície entre els programes d'usuari i el nucli del sistema operatiu. Aquestes crides són les que permeten als programes d'usuari accedir a les funcionalitats del sistema operatiu. En aquest laboratori, analitzarem la complexitat de les crides a sistema i les compararem amb les crides a procediments.

Les preguntes que ens fem són:

* Quina és la diferència de temps entre una crida a sistema i una crida a procediment?
* Quina és la complexitat d'una crida a sistema?
* Per què una crida es més costosa que l'altre?

## Objectius

* Comprendre el funcionament de les crides a sistema.
* Comparar el cost d'una crida a sistema amb el cost d'una crida a procediment.
* Dissenyar experiments en C.

## Tasca

Per respondre a les preguntes plantejades, dissenyarem un experiment en C que ens permeti mesurar el temps que triga una crida a sistema i una crida a procediment. Aquest experiment consistirà en cridar una funció simple i una crida a sistema un nombre determinat de vegades, i mesurar el temps que triga aquestes crides. Per exemple, podem utiltizar una crida a sistema com `getpid()` i una funció simple com `funcio()` que retorna un valor constant i calcular el temps que triga aquestes crides. Com a tota experimentació, caldrà repetir l'experiment un nombre suficient de vegades per obtenir resultats significatius, per exemple, 1000000 vegades i calcular el temps mitjà de cada crida.

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#define N_ITERATIONS 1000000

int funcio() {
    return 20;
}

int main() {

    struct timespec start, end;
    double totalTimeSysCall, totalTimeFuncCall;
    float avgTimeSysCall, avgTimeFuncCall;

    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int i = 0; i < N_ITERATIONS; i++) {
        funcio();
    }
    clock_gettime(CLOCK_MONOTONIC, &end);

    totalTimeFuncCall = (end.tv_nsec - start.tv_nsec);
    avgTimeFuncCall = totalTimeFuncCall / N_ITERATIONS;

    printf("Temps mitjà de la funció: %f ns\n", avgTimeFuncCall);


    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int i = 0; i < N_ITERATIONS; i++) {
        getpid();
    }
    clock_gettime(CLOCK_MONOTONIC, &end);

    totalTimeSysCall = (end.tv_nsec - start.tv_nsec);
    avgTimeSysCall = totalTimeSysCall / N_ITERATIONS;

    printf("Temps mitjà de la crida a sistema: %f ns\n", avgTimeSysCall);

    return 0;
}
```

En aquest codi, s'utilitza la funció `clock_gettime()` per mesurar el temps que triga una crida a sistema i una crida a procediment. Aquesta funció ens retorna una estructura `timespec` que conté el temps en segons i nanosegons (tv_sec o tv_nsec). Per a més informació, podeu consultar el manual de linux `man clock_gettime` o `man timespec`.

Per tal d'obtenir el temps transcorregut entre dues crides, es calcula la diferència entre el temps final i el temps inicial. Per tant, definim dues variables `start` i `end` de tipus `timespec` que contindran el temps abans i després de les crides. El temps total de les crides es calcula restant el temps final i el temps inicial. Finalment, es calcula el temps mitjà de les crides dividint el temps total pel nombre de crides realitzades.

> **Nota**: En aquest exemple, he simplificat el càlcul del temps per a facilitar la comprensió i per que cada mesura no excedira el segon. Si es vol fer una mesura més universal, es recomana utilitzar la següent fórmula: `totalTime = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9`. Ja que cada segon, la variable `tv_sec` incrementa en 1 i la variable `tv_nsec` es reinicia a 0. Això permet mesurar temps superiors a 1 segon.

---

> **Nota**: La variable `CLOCK_MONOTONIC` segons el manual de linux mesura el temps de forma monòtona, és a dir, no es veu afectada per salts discontinus en el temps del sistema.

Per executar aquest experiment, compilem el codi amb la següent comanda:

```bash
gcc experiment.c -o experiment -o0
```

Afegim l'opció `-o0` per desactivar l'optimització del compilador i obtenir resultats més precisos. El compilador de C, sovint optimitza el codi i això pot afectar als resultats. Per tant, desactivem l'optimització per obtenir resultats més fiables.

Un cop compilat, executem el programa amb la següent comanda:

```bash
./experiment
```

```bash
Temps mitjà de la funció: 5.298092 ns
Temps mitjà de la crida a sistema: 142.388794 ns
```

Com a resultat de l'experiment, es mostrarà el temps mitjà de la crida a sistema és molt més gran que el temps mitjà de la crida a procediment. Això és degut a la complexitat de les crides a sistema, que involucren moltes més operacions que una crida a procediment. Recordeu que les crides a sistema impliquen accedir al mode kernel, canviar de context, executar la crida a sistema i tornar al mode d'usuari, mentre que una crida a procediment és simplement una crida a una funció.

## Exercicis opcionals

1. Optimitza l'experiment per evitar repeticions de codi.
2. Optimitza la mesura del temps per obtenir resultats més generals aplicant la fórmula recomanada.
3. Modifica aquest experiment per comparar altres funcions i crides a sistema.
4. Crea un makefile per compilar el codi de forma més eficient.
