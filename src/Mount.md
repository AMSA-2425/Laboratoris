# Muntatge de Sistemes de Fitxers

-  En aquest capítol aprendrem com muntar i desmuntar sistemes de fitxers

## Muntatge Automàtic

- Es correspòn als sistemes de fitxers (s.f.) que es munten de forma automàtica en arrencar-se el sistema 
	(degut a l'execució de la comanda `\# mount -a`) es defineixen en el fitxer `/etc/fstab`:
  
	- Relaciona dispositius (particions) amb punts i opcions de muntatge. 

  	- Columnes (camps) de `/etc/fstab`: 
		dispositiu, 
		punt_de_muntatge, 
		tipus de sistema de fitxers
		opcions, 
		còpia (0 -no-, 1 -si-), 
		xequeig automàtic en muntar-se - `fsck` - (0 -no-, 1-si-).

- Comandes més importants:

	- Per muntar els dispositius que encara no estiguin muntats: 
	
	```bash
	# mount -a    /* els munta tots */
	```

	- Per muntar tots els sistemes de fitxers del tipus `tipus_sf`	

	```bash
	# mount -a -t tipus_sf
	```

	Exemple:
	
	![Exemple Debian 12 (UTM)](./figs/fstab.png)

## Muntatge No Automàtic

- Es correspòn al muntatge de s.f. que no estan definits en`/etc/fstab`

- Comandes més importants:

	```bash
	# mount -t tipus_sf dispositiu lloc
	```
	
	Exemple:
	```bash
	# mount -t vfat /dev/hda1 /tmp
	```




## Desmuntatge (Automàtic i no Automàtic)

- Llistant els dispositius (s.f.) muntats:

	```bash
	# mount 
	```
	Exemple (Debian 12 (UTM):
	```bash
	# mount | grep /dev/vda
	/dev/vda2 on /           type ext4 (rw,relatime,errors=remount-ro)
	/dev/vda1 on / boot/efi   type vfat  (rw,relatime,errors=remount-ro,utf8,.....)
	```


- Per desmuntar un dispositiu o s.f.: 

	```bash
	# umount [dispositiu | lloc]
	```
	Exemple:
	```bash
	# umount /dev/hda1
	```
	o bé (és equivalent):
	```bash
	# umount /tmp
	```
	