# Navegant per la Consola UEFI

Un cop identificats els dispositius disponibles, podeu utilitzar la consola UEFI per navegar per ells. Per exemple, per accedir a la partició ESP del disc NVMe1, podeu utilitzar la següent comanda:

```bash
Shell> fs1:
```

Això canviarà el directori de treball actual a la partició ESP del disc NVMe1. Si ara voleu accedir a `fs2`, podeu utilitzar la comanda `fs2:`.

```bash
Shell> fs2:
```

> **⚠️ Compte**
> La consola UEFI acostuma a tenir un keymap diferent al vostre. Els caràcters poden no ser els mateixos que els que veieu a la pantalla. Per exemple, la tecla `:` pot ser `ñ` o la tecla `/` pot ser `-`. Si teniu problemes amb les tecles podeu consultar el keymap de VMWare a la documentació oficial.

Un cop hàgiu accedit a una partició, podeu utilitzar la comanda `ls` per veure el contingut de la partició.

```bash
FS1:\> ls
```

La comanda `ls` us mostrarà una llista dels fitxers i directoris del directori actual. En aquest cas, veureu els fitxers i directoris del directori arrel de la partició ESP.

Finalment, podeu utilitzar la comanda `cd` per canviar de directori.

```bash
FS1:\> cd EFI
FS1:\EFI> ls
FS1:\EFI> cd ..
```
