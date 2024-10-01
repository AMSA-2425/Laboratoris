# LILO

LILO: Linux Loader

El fitxer de configuració del LILO és `/etc/lilo.conf`

Execució:

 `# apt-get install lilo`

`# lilo`




## Exemple LILO (fitxer /etc/lilo.conf)

lba32                        # adreces de bloc de 32 bits (discs grans)

boot=/dev/sda	        # lloc del MBR. En aquest cas el 1er disc SATA. hda seria el primer disc IDE

root=/dev/sda3 	        # partició que es montarà com a root

compact                    # intenta llegir sectors adjacents d'un cop

prompt                      # menu d'imatges

timeout=150              # espera 150*0.1=15 seg. abans d'arrencar la imatge per defecte

default=Debian267    #  imatge per defecte 

image=/boot/vmlinuz-2.6.7

      label=Debian267

      read-only

other=/dev/hda1

      label=Windows
