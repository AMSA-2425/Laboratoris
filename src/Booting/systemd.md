# Inici del sistema i Dimonis de gestió de serveis

Un cop el kernel ha estat carregat i ha completat el seu procés d’inicialització, crea un conjunt de processos *espontanis* en l’espai d’usuari. El primer d'aquests processos és el procés **init**, que és el pare de tots els altres processos en el sistema. El procés init és responsable de la inicialització del sistema i de la gestió de la resta de serveis. Tradicionalment, el procés init era conegut com a **SysVinit**, però amb el temps han sorgit alternatives com **systemd**.

> 🧐 El canvi de SysVinit a Systemd...
>
> En moltes distribucions Linux es va fer per millorar l’eficiència i la gestió dels serveis del sistema. SysVinit utilitza scripts seqüencials per iniciar serveis, cosa que pot ser lenta i menys flexible. En canvi, Systemd permet una arrencada paral·lela, reduint significativament el temps d’inici del sistema. A més, Systemd ofereix una gestió més avançada dels processos amb funcionalitats com els cgroups, que permeten controlar els recursos utilitzats per cada servei. Ara bé, aquest canvi també ha generat controvèrsia, ja que molts usuaris prefereixen el sistema més senzill i transparent de SysVinit.

En aquest laboratori, explorarem el procés d'arrencada del sistema amb **systemd** i com crear i gestionar serveis amb aquesta eina. També veurem com utilitzar **journalctl** per analitzar els registres del sistema i com personalitzar el procés d'arrencada amb scripts i serveis personalitzats.

## Objectius

- Comprendre el procés d'arrencada del sistema amb systemd.
- Crear i gestionar serveis amb systemd.
- Utilitzar journalctl per analitzar els registres del sistema.
- Personalitzar el procés d'arrencada amb scripts i serveis personalitzats.

## Preparació de l'entorn

Per a aquest laboratori, necessitarem un sistema Linux amb systemd instal·lat. Aquest laboratori es pot realitzar en qualsevol distribució Linux moderna que utilitzi systemd com a gestor d'inicialització. En aquest laboratori, utilitzarem una màquina virtual amb Debian 12. A més, assegureu-vos de no instal·lar la interfície gràfica, i seleccionar el servidor SSH durant la instal·lació.

## Tasques

1. [Analitzar el procés d'arrencada amb systemd](./systemd/analitzant.md)
2. [Crear i gestionar serveis amb systemd](./systemd/servei.md)
3. [Execució de serveis programats amb systemd](./systemd/programats.md)
4. [Anàlisi de registres del sistema amb journalctl](./systemd/logs.md)
5. [Afegir informació d'inici al sistema](./systemd/inici.md)
