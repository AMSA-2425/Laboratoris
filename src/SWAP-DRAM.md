# SWAP - DRAM

En aquesta secció aprendrem com administrar la memòria swap i com crear un disc ram.

## SWAP

Swap: Memòria d'intercanvi (en disc). 

	Memòria Virtual (MV) = Memòria Principal + Swap

- Si un procés esgota la MV \Longrightarrow el s.o. l'elimina

Solucions: 

1. Augmentar l'àrea (partició) de swap en disc 

2. Crear una nova àrea (partició) de swap en disc.

3. Crear un fitxer swap (p.e. en la partició arrel).


### Modificar/Crear una nova partició swap

1.
```bash
# fdisk /dev/hda

	d: esborrar una partició

	n: nova partició

		e: estesa

		p: primària

	l: llistar els tipus de particions 

	t: canviar a partició tipus swap (82)

	w: desar canvis i sortir

	q: sortir sense desar els canvis
```

2.
```bash
# mkswap /dev/hda5     % crea una nova zona swap en /dev/hda5
```

3.
```bash
# swapon /dev/hda5 % activa la nova zona swap (/dev/hda5)
```

4.
```bash
# swapoff /dev/hda5 %  desactiva la nova zona swap (/dev/hda5)
```

5.
```bash
# free % per comprovar que s'hagi afegit correctament
```

- Per que el sistema, en arrencar-se, carregui correctament la nova zona de swap --> en `/etc/fstab` s'ha d'afegir: 

```bash
/dev/hda5      none      swap      defaults      0 0 
```

### Creació d'un fitxer swap

```bash
#!/bin/bash

# Swap\\

ROOT_UID=0  % root té $UID = 0.

FILE=/tmp/swap

BLOCKSIZE=1024; MINBLOCKS=40

[ "$UID" -ne "$ROOT_UID" ] && echo "no autoritzat" && exit 1

blocks=${1:-$MINBLOCKS} % default  40 blocs

[ "$blocks" -lt $MINBLOCKS ]  && echo "blocks > $MINBLOCKS" && exit 2

dd if=/dev/zero of=$FILE bs=$BLOCKSIZE count=$blocks

/sbin/mkswap -f $FILE $blocks % crea fitxer swap

/sbin/swapon $FILE % # Activa el fitxer swap

echo "Fitxer Swap creat i activat"

exit 0
```


- ¿  # dd if=/dev/zero of=$FILE bs=$BLOCKSIZE count=$blocks   ? 

	- Per mirar mida Swap: # free -b   % en bytes 

	- Desactivació d'un fitxer swap: # swapoff fitxer

	- Esborrat fitxer swap: # rm fitxer
	

## DRAM

Disc RAM: sistema de fitxers implementat en RAM. Exemple: sistema de fitxers /proc.

	- Com podem fer que els accessos a disc (entre 10-20 milisegons) siguin més ràpids? --> utilitzant discs RAM.

- Possibles aplicacions:

	1. Bases de dades

	2. Servidors Web

	3. Monitorització del sistema en temps real
	
### Creació d'un disc RAM amb un script

```bash
#!/bin/bash 

# Ramdisk

ROOTUSER_NAME=root

MOUNTPT=/tmp/ramdisk

SIZE=2048  %  2K blocs

BLOCKSIZE=1024 % mida bloc: 1K (1024 bytes) 

DEVICE=/dev/ram0 % Primer Ram Disc

username=`id -nu` % equivalent a fer username=$USER

[ "$username" != "$ROOTUSER_NAME" ] && echo "no autoritzat" && exit 1

[ ! -d "$MOUNTPT" ] && mkdir $MOUNTPT

dd if=/dev/zero of=$DEVICE count=$SIZE bs=$BLOCKSIZE

/sbin/mke4fs $DEVICE % Crea un s. de fitxers ext4

% també es podria fer mkfs -t ext4 $DEVICE , o bé mkfs.ext4 $DEVICE

mount $DEVICE $MOUNTPT % el munta

chmod 777 $MOUNTPT 

echo $MOUNTPT " disponible"

exit 0
```

### Creació d'un disc RAM amb comandes

```bash
# ls   -l   /dev/ram0

# ls   -l   /tmp/ramdisk

# mount   /dev/ram0   /tmp/ramdisk

# cp   SWAP-DRAM.lyx   /tmp/ramdisk

# rm   /tmp/ramdisk/SWAP-DRAM.lyx

# ls   -l   /tmp/ramdisk

# umount /tmp/ramdisk

# rmdir /tmp/ramdisk
```
