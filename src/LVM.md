# LVM

- Swap: Memòria d'intercanvi (en disc). 

		- Memòria Virtual (MV) = Memòria Principal + Swap

- Si un procés esgota la MV --> el s.o. l'elimina.

	Solucions: 

		1. Augmentar l'àrea (partició) de swap en disc 

		2. Crear una nova àrea (partició) de swap en disc.

		3. Crear un fitxer swap (p.e. en la partició arrel).


## Modificar/Crear una nova partició swap

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
	# mkswap /dev/hda5     # crea una nova zona swap en /dev/hda5
	```

3.
	```bash
	# swapon /dev/hda5  	# activa la nova zona swap (/dev/hda5)
	```

4.
	```bash
	# swapoff /dev/hda5 		# desactiva la nova zona swap (/dev/hda5)
	```

5.
	```bash
	# free 	# per comprovar que s'hagi afegit correctament
	```

- Per que el sistema, en arrencar-se, carregui correctament la nova zona de swap --> en `/etc/fstab` s'ha d'afegir: 

	```bash
	/dev/hda5      none      swap      defaults      0 0 
	```

## Creació d'un fitxer swap

```bash
#!/bin/bash

# script SWAP

ROOT_UID=0        # root té $UID = 0.

FILE=/tmp/swap

BLOCKSIZE=1024

MINBLOCKS=40

[ $UID -ne 0 ] && echo "no autoritzat" && exit 1	# UID de root = 0

blocks=${1:-$MINBLOCKS}         #  default  40 blocs

[ $blocks -lt $MINBLOCKS ]  && echo "blocks > $MINBLOCKS" && exit 2

dd if=/dev/zero of=$FILE bs=$BLOCKSIZE count=$blocks

/sbin/mkswap -f $FILE $blocks	# crea fitxer swap

/sbin/swapon $FILE  		# Activa el fitxer swap

echo "Fitxer swap creat i activat"

exit 0
```


- ¿  # dd if=/dev/zero of=$FILE bs=$BLOCKSIZE count=$blocks   ? 

- Per mirar mida Swap: 
	```bash  
	# free -b   # en bytes 
	```
	
- Desactivació d'un fitxer swap: 
	```bash
	# swapoff fitxer
	```
	
- Esborrat fitxer swap: 
	```bash
	# rm fitxer
	```