# Compilant el Kernel de Linux

En aquest laboratori, compilarem el kernel de Linux. La compilació del kernel és un procés complex i tedios. La compilació del kernel és un procés que implica la creació d'un nou kernel personalitzat a partir dels *sources* del kernel de Linux.

## Requeriments previs

En primer lloc, accedirem a una sessió com a usuari root per poder instal·lar tots els paquets que necessitarem per realitzar el laboratori.

```sh
su - root
```

1. Instal·la les eines essencials per a la construcció de programar:

    ```sh
    apt install build-essential libncurses-dev bison flex kmod bc -y
    ```

2. Instal·la utilitats per a l'ús de l'algoritme de compressió XZ i el desenvolupament amb SSL:

    ```sh
    apt install xz-utils libssl-dev  -y
    ```

3. Manipulació de fitxers ELF:

    ```sh
    apt install libelf-dev dwarves -y
    ```

4. Instal·la les capçaleres del nucli de Linux corresponents a la versió actual del teu sistema (obtinguda amb **uname -r**):

    ```sh
    apt install linux-headers-$(uname -r) -y 
    ```

Finalment tornem a una sessió d'usuari normal:

```sh
exit
```

Com a usuari normal, reviseu quin és la versió del kernel actual:

```sh
uname -r
```

En el meu cas és 6.1.0-25-arm64.

> **Nota**:
>
> Us recomano en aquest punt fer un clon de la vostra màquina virtual per si es produeix algun error durant la compilació del kernel.

A més a més, a la màquina clonada, us recomano que li adjunteu un nou disc virtual de 60 GB per poder compilar el kernel i no quedar-vos sense espai en disc. Un cop adjuntat el nou disc, podeu seguir els passos següents per muntar-lo i comprovar que s'ha afegit correctament.

```sh
lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sr0          11:0    1 526,3M  0 rom
nvme0n1     259:0    0    20G  0 disk
├─nvme0n1p1 259:1    0   512M  0 part /boot/efi
├─nvme0n1p2 259:2    0  18,5G  0 part /
└─nvme0n1p3 259:3    0   976M  0 part [SWAP]
nvme0n2     259:4    0    60G  0 disk 
```

Per obtenir l'etiquesta del disc nou que heu afegit. En el meu cas és **nvme0n2**.

Un cop tingueu l'etiqueta del disc nou, podeu formatar-lo i muntar-lo.

```sh
mkfs.ext4 /dev/nvme0n2
mount /dev/nvme0n2 /mnt
```

Quan us baixeu els *sources* del kernel, feu-ho a la carpeta **/mnt** que és on teniu el disc nou muntat.

## Obtenció d'un kernel

Baixeu l'última versió del nucli 6.11.1 de [kernel.org](https://www.kernel.org/) i descomprimiu els *sources* a la vostra màquina virtual. Podeu baixar els fitxers directament a **/root**.

```sh
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.11.1.tar.xz
tar -xJf linux-6.11.1.tar.xz
cd linux-6.11.1/
```

## Configuració del Kernel

La configuració del kernel és un pas crucial en el procés de compilació, ja que permet personalitzar el kernel segons les necessitats i requeriments específics del sistema en què s'implementarà. Aquesta personalització pot incloure adaptar el kernel per garantir la compatibilitat amb el maquinari disponible i afegir funcionalitats específiques que l'usuari desitja integrar. Per exemple, es pot afegir el sistema de fitxer avançats com **zfs** o **btrfs**. Un usuari avançat es pot fer un kernel a mida per optimitzar el rendiment del sistema.

Ara bé, en aquest laboratori, per configurar el kernel, partirem de la configuració actual del vostre sistema :

```sh
cp -v /boot/config-$(uname -r) .config
```

A continuació, pots fer ajustos de configuració, en el nostre cas no farem cap canvi, únicament guardarem la configuració actual. Per realitzar la comanda següent heu de ser **root** i estar al directori on heu descomprimit els *sources* del kernel.

```sh
make menuconfig
```

En aquest punt, accedirem a una interfície gràfica per configurar el kernel. Aquesta interfície ens permetrà seleccionar les opcions de configuració del kernel. Si no voleu fer cap canvi, podeu sortir de l'interfície sense guardar cap canvi. Si voleu fer canvis, podeu fer-ho i desar la configuració.

## Edició de .config

Utilitzeu un editor de text per editar el fitxer de configuració del kernel. Cerca la configuració `CONFIG_SYSTEM_TRUSTED_KEYS` i assigna-li el valor de cadena buida. Si ja té aquest valor assignat a la cadena buida, no cal fer cap canvi.

```sh
vi .config
# Premeu / i després escriviu el patró a cercar
# Cerca: CONFIG_SYSTEM_TRUSTED_KEYS
# Edita: CONFIG_SYSTEM_TRUSTED_KEYS=""
# Desa i surt (wq!)
```

## Compilació i Instal·lació

Utilitzarem l'eina **screen** que ens permetrà deixar la compilació en segon pla i poder fer altres tasques. **No tanqueu la màquina virtual**. La shell o el visual code els podeu tancar. Deixeu el procés **overnight** i al matí podreu veure el resultat.

```sh
su -c "apt install screen -y"
```

```sh
screen -S compilantKernel
```

Utilitzarem l'eina **make** per compilar el kernel. Aquesta eina ens permet compilar de forma paral·lela. El nombre de processos que es poden executar de forma paral·lela es pot especificar amb l'opció **-j**. En el nostre cas, utilitzarem el nombre de processadors disponibles a la nostra màquina virtual obtinguts amb ```nproc```.

> **Nota**:
>
> Abans d'executar la comanda, intenteu parar la màquina virtual i assignar-li el màxim nombre de processadors que pugueu. Això accelerarà el procés de compilació.

```sh
make  ARCH=x86_64 -j `nproc` && make ARCH=x86_64 modules_install -j `nproc` && make ARCH=x86_64 install -j `nproc`
# enter
# Això pot trigar... paciencia ^^
```

> **Nota**:
>
> Si utilitzeu una màquina física amb ARM, com un MAC M, heu de canviar l'arquitectura a **arm64** en l'opció **ARCH**.

Per sortir de la sessió de screen i poder realitzar altres tasques a la màquina virtual:

```sh
# Premeu Ctrl+A i després d
```

* Per tornar a la sessió de screen:

```sh
screen -r compilantKernel
```

Un cop finalitzada la compilació, actualitzarem el grub per poder seleccionar el nou kernel que hem compilat.

```sh
reboot
```

Un cop arranqui la màquina virtual, podreu seleccionar el nou kernel a les opcions avançades del grub. En aquest punt, podeu seleccionar la versió del kernel que voleu carregar.

## Activitats de seguiment

1. Genereu un document en format markdown amb les captures de pantalla de la compilació del kernel i com seleccioneu el nou kernel a l'arrencada i el kernel anterior. **Podeu editar kernel.md del repositori**.
