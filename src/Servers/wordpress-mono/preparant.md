# Preparant el servidor

Un cop creada la màquina virtual, el primer pas és actualitzar el sistema operatiu amb la comanda següent per assegurar-nos que disposem de les últimes actualitzacions de seguretat.

> 💡 **Nota**
>
> Mantenir el sistema operatiu actualitzat és una responsabilitat fonamental de qualsevol administrador de sistemes, ja que garanteix l'estabilitat i la seguretat del servidor. Per això, és recomanable començar qualsevol configuració executant una actualització completa del sistema.

```bash
dnf -y update
```

Aquesta comanda actualitza tots els paquets del sistema utilitzant el gestor de paquets DNF. L'opció `-y` respon automàticament sí a totes les preguntes de confirmació, permetent que l'actualització es realitzi sense intervenció manual.

A més, si preferiu utilitzar un editor de text diferent de `vi`, podeu instal·lar alternatives com `vim`, `emacs` o `nano` amb les comandes següents:

```bash
dnf install vim -y
dnf install nano -y
dnf install emacs -y
```

Es recomanable tenir un script amb el resum de les comandes que s'han d'executar per preparar el servidor. Així, si cal crear un nou servidor o repetir la configuració en un altre moment, es pot utilitzar aquest script per automatitzar el procés.

```bash
#!/bin/bash

# Actualitzar el sistema
dnf -y update

# Instal·lar editors de text
dnf install vim -y
```
