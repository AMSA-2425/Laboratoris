# Instal·lant i configurant PHP

Actualment, la documentació oficial de WordPress recomana utilitzar PHP versió 7.4 o superior per a un funcionament òptim i segur del sistema. 

1. Compovem si el paquet **php** està disponible:

    ```sh
    dnf search php
    ```

2. Comprovem les versions disponibles de PHP:

    ```sh
    dnf module list php
    ```

    Aquesta comanda mostra una llista de les versions del mòdul PHP disponibles. Et permetrà veure quines versions de PHP pots instal·lar mitjançant mòduls.

3. Instal·lem la versió 8.1 de PHP:

    ```sh
    dnf module install php:8.1 -y
    ```

   L'ús de versions més recents de PHP ofereix molts avantatges, com ara un millor rendiment, més seguretat i noves característiques. Les versions antigues de PHP poden ser més vulnerables a problemes de seguretat i tenir limitacions de rendiment. Per tant, és important seguir les recomanacions de la documentació oficial de **WordPress** quant a la versió de PHP que has d'utilitzar per a la teva instal·lació.

   Un cop instal·lada la versió de PHP, podem comprovar la versió actual amb la comanda `php -v`. I començar a instal·lar els paquets i complements necessaris:

    ```sh
    dnf install php-curl php-zip php-gd php-soap php-intl php-mysqlnd php-pdo -y
    ```

    * **php-curl**: Proporciona suport per a cURL, que és una llibreria per a la transferència de dades amb sintaxi URL.
    * **php-zip**: Proporciona suport per a la manipulació de fitxers ZIP.
    * **php-gd**: Proporciona suport per a la generació i manipulació d'imatges gràfiques.
    * **php-soap**: Proporciona suport per a la creació i consum de serveis web SOAP.
    * **php-intl**: Proporciona suport per a la internacionalització i localització de l'aplicació.
    * **php-mysqlnd**: És l'extensió MySQL nativa per a PHP, que permet la connexió i la comunicació amb bases de dades MySQL o MariaDB.
    * **php-pdo**: Proporciona l'abstracció de dades d'Objectes PHP (PDO) per a la connexió amb bases de dades.

4. Per finalitzar, podem reiniciar el servei web (httpd).

    ```sh
    systemctl restart httpd
    ```
