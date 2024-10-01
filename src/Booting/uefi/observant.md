# Observant els Dispositius Disponibles

Un dels usos més comuns de la consola UEFI és la selecció del dispositiu d'arrancada. Per veure quins dispositius estan disponibles, podeu utilitzar la comanda `map`.

```bash
Shell> map
```

Aquesta comanda us mostrarà una llista de tots els dispositius disponibles i les seves adreces. Això us permetrà identificar quin dispositiu voleu utilitzar per a l’arrancada. En el nostre cas, us retornarà una llista similar a aquesta:

- `FS0`: Alias(s):CD0B0A0;;BLK1:
        PciRoot(OxO)/Pci(0x11,0x0)/Pci(0x3,0x0)/Sata(0x1,0x0,0x0)/CDROM(0x0)

- `FS1`: Alias(s):HD1b;;BLK3:
        PciRoot(0x0)/Pci(0x17,0x0)/Pci(0x0,0x0)/NVMe(0x1,00-00-00-00-00-00-00-00)/HD(1,GPT,61942D3C-DD95-47F4-8C57-C22009E9C7BA,0x800,0x12C000)

- `FS2`: Alias(s):HD2b;;BLK7:
         PciRoot(0x0)/Pci(0x17,0x0)/Pci(0x0,0x0)/NVMe(0x2,00-00-00-00-00-00-00-00)/HD(1,GPT,8DD9095B-5B0C-45A3-A026-33DE34ED23B5,0x800,0x10000)

- `BLK0`: Alias(s):
          PciRoot(0x0)/Pci(0x11,0x0)/Pci(0x3,0x0)/Sata(0x1,0x0,0x0)

- `BLK2`: Alias(s):
          PciRoot(0x0)/Pci(0x17,0x0)/Pci(0x0,0x0)/NVMe(0x1,00-00-00-00-00-00-00-00)

- `BLK6`: Alias(s):
          PciRoot(0x0)/Pci(0x17,0x0)/Pci(0x0,0x0)/NVMe(0x2,00-00-00-00-00-00-00-00)

- `BLK4`: Alias(s):
          PciRoot(0x0)/Pci(0x17,0x0)/Pci(0x0,0x0)/NVMe(0x1,00-00-00-00-00-00-00-00)/HD(2,GPT, 7D330E0D-0E09-440C-A79D-9239BD9F11C0,0x12C800,0x200000)

- `BLK5`: Alias(s):
          PciRoot(0x0)/Pci(0x17,0x0)/Pci(0x0,0x0)/NVMe(0x1,00-00-00-00-00-00-00-00)/HD(3,GPT, 94B55114-4795-4748-AD0E-BB068D437691,0x32C800,0x24D3000)

- `BLK8`: Alias(s):
          PciRoot(0x0)/Pci(0x17,0x0)/Pci(0x0,0x0)/NVMe(0x2,00-00-00-00-00-00-00-00)/HD(2,GPT, 760F1F2F-BA6F-479C-8D4D-8FA31D9226F6,0x100800,0x251700)

- `BLK9`: Alias(s):
          PciRoot(0x0)/Pci(0x17,0x0)/Pci(0x0,0x0)/NVMe(0x2,00-00-00-00-00-00-00-00)/HD(3,GPT, CD375C90-A2BA-4507-9263-55BE97B26672,0x2617800,0x1E8000)

En aquest cas, tenim 3 sistemes de fitxers (FS0, FS1, FS2) i diversos dispositius de bloc (BLK0, BLK2, BLK6, BLK4, BLK5, BLK8, BLK9).

Els sistemes de fitxers representen dispositius que contenen un sistema de fitxers que la UEFI pot llegir. Això inclou dispositius com discos durs, SSDs, i CD-ROMs. Per exemple, FS0 representa un CD-ROM, mentre que FS1 i FS2 representen discos durs.