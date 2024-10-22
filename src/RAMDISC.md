# Disc RAM (DRAM)

Disc RAM: sistema de fitxers implementat en RAM. Exemple: sistema de fitxers /proc.

- Com podem fer que els accessos a disc (entre 10-20 milisegons) siguin més ràpids? 
	--> utilitzant discs RAM.

	- Possibles aplicacions:

		1. Bases de dades

		2. Servidors Web

		3. Monitorització del sistema en temps real
	
## Creació d'un disc RAM amb un script

```bash
#!/bin/bash 

# script DRAM

ROOTUSER_NAME=root

MOUNTPT=/tmp/ramdisk

SIZE=2048		# 2K blocs

BLOCKSIZE=1024		# mida bloc: 1K (1024 bytes) 

DEVICE=/dev/ram0	# Primer  Disc Ram

USERNAME=`id -nu`	

[ "$USERNAME" != "root" ] && echo "no autoritzat" && exit 1

[ ! -d "$MOUNTPT" ] && mkdir $MOUNTPT

dd if=/dev/zero of=$DEVICE count=$SIZE bs=$BLOCKSIZE

/sbin/mke4fs $DEVICE	# Crea un sistema de fitxers ext4 en el disc ram /dev/ram0

# també es podria fer mkfs -t ext4 $DEVICE , o bé mkfs.ext4 $DEVICE

mount $DEVICE $MOUNTPT	#  el munta

chmod 0777 $MOUNTPT 

echo $MOUNTPT "disponible"

exit 0
```

## Creació d'un disc RAM amb comandes

```sh
# ls  -l  /dev/ram0

# ls  -l  /tmp/ramdisk

# mount  /dev/ram0  /tmp/ramdisk

# cp  fitxer.txt  /tmp/ramdisk

# rm  /tmp/ramdisk/fitxer.txt

# ls  -l  /tmp/ramdisk

# umount /tmp/ramdisk

# rmdir /tmp/ramdisk
```
