# Instal·lació d'una màquina virtual

Per a realitzar tots els laboratoris d'aquest curs, necessitareu una màquina virtual amb un sistema operatiu basat en Linux. En aquest curs us proposo utilitzar, dos distribucions molt populars per a servidors en entorns de producció.

1. **Debian 12**: Debian és una distribució de Linux molt popular i estable. És una de les distribucions més antigues i utilitzades en servidors. Debian és conegut per la seva estabilitat, seguretat i facilitat d'ús. És una excel·lent opció per a servidors web, servidors de correu electrònic, servidors de bases de dades i altres aplicacions de servidor. Concretament, utilitzarem la versió 12.5.0.

2. **AlmaLinux 9**: AlmaLinux és una distribució de Linux basada en Red Hat Enterprise Linux (RHEL). És una distribució de Linux empresarial que ofereix suport a llarg termini i actualitzacions de seguretat. Es una de les alternativa open-source de RHEL. Concretament, utilitzarem la versió 9.4.

## Software de virtualització

En aquest curs, us recomano utilitzar VMWare com a software de virtualització. VMWare és un dels software de virtualització més populars i utilitzats en entorns de producció. A més, VMWare ofereix una versió gratuïta per a ús personal i educatiu:

- Windows: [VMWare Workstation Player](https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html)
- Mac: [VMWare Fusion](https://www.vmware.com/products/fusion/fusion-evaluation.html)

A més, VMWare funciona en les principals arquitectures de processador com x86 i ARM. Durant el curs, els exemple i el suport es basaran en l'ús de VMWare. Resta a la vostra elecció utilitzar un altre software de virtualització com VirtualBox, KVM, UTM o d'altres.

## Tasques

1. [Instal·la un màquina virtual amb Debian 12.5.0 en mode text](./debian.md)
2. [Informació bàsica sobre hostname i `hostnamectl`](./hostname.md)
3. [Informació bàsica sobre resolució de noms](./hosts.md)
4. [Informació bàsica sobre com connectar-se a una màquina virtual amb SSH i transferència de fitxers](./ssh.md)

## Activitats

- Documenta el procés d'instal·lació de la màquina virtual amb AlmaLinux 9.4 amb una interfície gràfica.
- Descriu les diferències entre el procés d'instal·lació de les dues distribucions.
- Investiga com es pot crear un clon d'una màquina virtual amb VMware i documenta el procés. Comenta els avantatges i inconvenients de clonar una màquina virtual.

## Rúbriques d'avaluació

**Realització de les tasques**: 100%

| Criteris d'avaluació      | Excel·lent (5) | Notable(3-4) | Acceptable(1-2)  | No Acceptable (0) |
|---------------------------|----------------|--------------|------------------|-------------------|
| **Contingut**                 | El contingut és molt complet i detallat. S'han cobert tots els aspectes de la tasca. | El contingut és complet i detallat. S'han cobert la majoria dels aspectes de la tasca. | El contingut és incomplet o poc detallat. Falten alguns aspectes de la tasca. | El contingut és molt incomplet o inexistent.|
| **Estil**                     | L'estil és molt adequat i professional. S'ha utilitzat un llenguatge tècnic precís. | L'estil és adequat i professional. S'ha utilitzat un llenguatge tècnic precís. | L'estil és poc adequat o professional. Hi ha errors en el llenguatge tècnic. | L'estil és molt poc adequat o professional. Hi ha molts errors en el llenguatge tècnic. |
| **Precisió i exactitud**      | La informació és precisa i exacta. No hi ha errors. | La informació és precisa i exacta. Hi ha pocs errors. | La informació és imprecisa o inexacta. Hi ha errors. | La informació és molt imprecisa o inexacta. Hi ha molts errors. |
| **Organització**              | La informació està ben organitzada i estructurada. És fàcil de seguir. | La informació està organitzada i estructurada. És fàcil de seguir. | La informació està poc organitzada o estructurada. És difícil de seguir. | La informació està molt poc organitzada o estructurada. És molt difícil de seguir. |
| **Justificació** | S'han justificat les respostes amb arguments vàlids i exemples pràctics. | S'han justificat les respostes amb arguments vàlids. | S'han justificat les respostes amb arguments poc vàlids. | No s'han justificat les respostes. |
| **Expansió** | S'han ampliat les respostes amb informació addicional rellevant. | S'han ampliat les respostes amb informació addicional. | S'han ampliat les respostes amb informació poc rellevant. | No s'han ampliat les respostes. |
| **Suport gràfic o audiovisual** | S'han utilitzat recursos gràfics o audiovisuals per aclarir la informació. | S'han utilitzat recursos gràfics o audiovisuals. | S'han utilitzat pocs recursos gràfics o audiovisuals. | No s'han utilitzat recursos gràfics o audiovisuals. |
