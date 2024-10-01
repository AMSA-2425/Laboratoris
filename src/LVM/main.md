# Logical Volume Manager (LVM)

En aquest laboratori aprendràs a configurar i gestionar un sistema de fitxers basat en LVM (Logical Volume Manager) en un servidor Linux. Aquesta tecnologia permet una gestió flexible de l'espai de disc, permetent redimensionar, afegir i eliminar particions sense necessitat de reiniciar el sistema.

## Contextualització

Imagineu que sou l'administrador d'un servidor Linux que allotja una aplicació web. Les característiques del servidor les anirem detallant al llarg de les tasques. La vostra tasca és analitzar el sistema actual que utilitza particions tradicionals i valorar la possibilitat de migrar a LVM. A més a més, haureu d'intentar optimitzar el sistema.

## Objectius

Els objectius d'aquest laboratori són:

- Comprendre els conceptes bàsics de LVM.
- Analitzar els diferents modes de funcionament de LVM.
- Realitzar una migració completa a LVM.
- Implementar operacions avançades amb LVM, com ara snapshots i thin provisioning.
- Revisar les metadadades en LVM i el seu impacte.

## Tasques

1. [Anàlisi dels modes striped i linear](./striped-linear.md)
2. [Migració a LVM](./migration.md)
3. [Desplegament d'una web amb LVM](./usage.md)
4. [Gestió de fallades](./failures.md)
5. [Snapshots](./snapshots.md)
6. [Mirroring](./mirroring.md)

## Rúbriques d'avaluació

**Realització de les tasques**: 50%

S'ha de mostrar en un document amb format lliure les evidències de la realització de les tasques. Aquest document es pot incloure al informe tècnic o es pot lliurar com a document adjunt.

**Informe tècnic**: 50%

S'ha de lliure un informe tècnic que agrupi tots els requeriments i la situació inicial del servidor. A més a més, heu de fer una proposta de canvis i justificar-los. L'informe ha de respondre de forma directa o indirecta, les preguntes d'analisi de les diferents tasques.

| Criteris d'avaluació      | Excel·lent (5) | Notable(3-4) | Acceptable(1-2)  | No Acceptable (0) |
|---------------------------|----------------|--------------|------------------|-------------------|
| Contingut                 | El contingut és molt complet i detallat. S'han cobert tots els aspectes de la tasca. | El contingut és complet i detallat. S'han cobert la majoria dels aspectes de la tasca. | El contingut és incomplet o poc detallat. Falten alguns aspectes de la tasca. | El contingut és molt incomplet o inexistent.|
| Precisió i exactitud       | La informació és precisa i exacta. No hi ha errors. | La informació és precisa i exacta. Hi ha pocs errors. | La informació és imprecisa o inexacta. Hi ha errors. | La informació és molt imprecisa o inexacta. Hi ha molts errors. |
| Organització              | La informació està ben organitzada i estructurada. És fàcil de seguir. | La informació està organitzada i estructurada. És fàcil de seguir. | La informació està poc organitzada o estructurada. És difícil de seguir. | La informació està molt poc organitzada o estructurada. És molt difícil de seguir. |
| Diagrames i il·lustracions | S'han utilitzat diagrames i il·lustracions de collita pròpia per aclarir la informació. Són molt útils. | S'han utilitzat diagrames i il·lustracions de collita pròpia per aclarir la informació. Són útils. | S'han utilitzat pocs diagrames o il·lustracions de collita pròpia. Són poc útils. | No s'han utilitzat diagrames o il·lustracions de collita pròpia.|
| Plagi                     | No hi ha evidències de plagi. Tota la informació és original. | Hi ha poques evidències de plagi. La majoria de la informació és original. | Hi ha evidències de plagi. Alguna informació no és original. | Hi ha moltes evidències de plagi. Poca informació és original. |
| Bibliografia              | S'ha inclòs una bibliografia completa i detallada. | S'ha inclòs una bibliografia completa. | S'ha inclòs una bibliografia incompleta. | No s'ha inclòs una bibliografia. |
| Estil                     | L'estil és molt adequat i professional. S'ha utilitzat un llenguatge tècnic precís. | L'estil és adequat i professional. S'ha utilitzat un llenguatge tècnic precís. | L'estil és poc adequat o professional. Hi ha errors en el llenguatge tècnic. | L'estil és molt poc adequat o professional. Hi ha molts errors en el llenguatge tècnic. |
