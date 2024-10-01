# Instal·lació d'una màquina virtual

Per a realitzar tots els laboratoris d'aquest curs, necessitareu una màquina virtual amb un sistema operatiu basat en Linux. En aquest curs es proposa utilitzar 3 distribucions molt populars per a servidors en entorns de producció.

1. **Debian 12**: Debian és una distribució de Linux molt popular i estable. És una de les distribucions més antigues i utilitzades en servidors. Debian és conegut per la seva estabilitat, seguretat i facilitat d'ús. És una excel·lent opció per a servidors web, servidors de correu electrònic, servidors de bases de dades i altres aplicacions de servidor. Es recomana utilitzar la versió 12.5.0.

2. **AlmaLinux 9**: AlmaLinux és una distribució de Linux basada en Red Hat Enterprise Linux (RHEL). És una distribució de Linux empresarial que ofereix suport a llarg termini i actualitzacions de seguretat. Es una de les alternativa open-source de RHEL. Es recomana utilitzar la versió 9.4.

3. **Ubuntu**. Ubuntu és un sistema operatiu basat en Linux desenvolupat per Canonical Ltd. Està dissenyat per ser fàcil d’usar, segur i accessible per a tot tipus d’usuaris, des de principiants fins a experts.  La versió actual estable d’Ubuntu és la 22.04 LTS (Long Term Support).

## Software de virtualització

Els més populars i lliures són:

- VMMWare. Disponible per  arquitectures de processador  x86 i ARM.
	- Windows: [VMWare Workstation Player](https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html)
	- Mac: [VMWare Fusion](https://www.vmware.com/products/fusion/fusion-evaluation.html)
- UTM.  [Mac](https://mac.getutm.app/). Disponible per  arquitectures de processador ARM.
- VirtualBox. Mac i Windows. Disponible per  arquitectures de processador x86.

## Contingut

1. [Instal·lació d'una màquina virtual amb Debian 12.5](./debian.md)
2. [Informació bàsica sobre hostname i `hostnamectl`](./hostname.md)
3. [Informació bàsica sobre resolució de noms](./hosts.md)
4. [Informació bàsica sobre com connectar-se a una màquina virtual amb SSH i transferència de fitxers](./ssh.md)
