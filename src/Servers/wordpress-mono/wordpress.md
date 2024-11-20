# Instal·lant i configurant Wordpress

Per instal·lar **WordPress** ens hem de baixar el paquet de la web oficial. Per fer-ho podem utilitzar la comanda `wget` per descarregar el paquet de **WordPress**.

1. Instal·lem el paquet **wget**:

    ```bash
    apt install wget -y
    ```

2. Descarreguem el paquet de **WordPress**:

    Es una bona pràctica utilitzar el directori temporal (*/tmp*) per descarregar el programari a instal·lar com el *Wordpress*. L'ús d'aquest directori ens proporciona:

   * **Espai de disc temporal**: Ubicació on es poden emmagatzemar fitxers sense preocupar-se pel seu ús posterior. És una ubicació amb prou espai de disc disponible, generalment, i sol estar netejada periòdicament pels sistemes operatius per evitar l'acumulació de fitxers temporals innecessaris.

   * **Evitar problemes de permisos**: El directori temporal (*/tmp*) sol tenir permisos que permeten a tots els usuaris crear fitxers temporals sense problemes de permisos. Això és important quan estàs treballant amb fitxers que poden ser manipulats per diversos usuaris o processos.

   * **Seguretat**: Com que el directori temporal és netejat periòdicament, hi ha menys risc de deixar fitxers temporals sensibles o innecessaris al sistema després d'una operació. Això ajuda a prevenir la acumulació de residus i a minimitzar els problemes de seguretat relacionats amb fitxers temporals.

   * **Evitar col·lisions de noms de fitxers**: Utilitzant el directori temporal, es redueixen les possibilitats de col·lisions de noms de fitxers. En altres paraules, si molts usuaris estan descarregant fitxers a la mateixa ubicació, utilitzar el directori temporal ajuda a garantir que els noms de fitxers siguin únics.

   En resum, garanteix l'espai, la seguretat i la gestió adequats per a aquest tipus de fitxers, com és el cas de la descàrrega i descompressió de paquets com WordPress.

    ```bash
    cd /tmp
    wget https://wordpress.org/latest.tar.gz -O wordpress.tar.gz
    ```

3. Després d'haver descarregat el paquet, el descomprimim amb la comanda `tar`:

    ```bash
    apt install tar -y
    tar -xvf wordpress.tar.gz
    ```

4. Copiem els continguts a la carpeta del servidor **Apache**:

    ```bash
    cp -R wordpress /var/www/html/
    ```

5. Editem fitxer de configuració del servidor web, normalment a */etc/httpd/conf/httpd.conf*.

    ```bash
    less /etc/httpd/conf/httpd.conf
    ```

6. Reiniciem el servei **Apache**:

    ```bash
    # systemctl restart apache2
    ```

## Instal·lació del Wordpress

Un cop completat aquests passos, ja podeu accedir a la instal·lació web de **WordPress** navegant a [http://192.168.64.11/wordpress/](http://192.168.64.11/wordpress/). On *192.168.64.11* és la ip del meu servidor. Canvieu-la per la vostra ip. 

El primer pas serà completar un formulari amb la informació de la base de dades que hem creat anteriorment. Aquesta informació és necessària per connectar **WordPress** a la base de dades i emmagatzemar-hi la informació del lloc web.

* **Nom de la base de dades**: `wordpress-db`
* **Nom d'usuari de la base de dades**: `wordpress-user`
* **Contrasenya de la base de dades**: `amsa`
* **Servidor de la base de dades**: `localhost`
* **Prefix de la taula**: `wp_`

Un cop hàgiu introduït aquesta informació, podeu continuar amb el procés d'instal·lació de **WordPress**.


1. Inici de la configuració:

    ![Click a Let's go](../figures/wordpress-mono/wp1.png)

2. Introdueix les dades de la base de dades:

    ![Configuració de la base de dades](../figures/wordpress-mono/wp2.png)

3. Realitza la instal·lació:

    ![Configuració del lloc web](../figures/wordpress-mono/wp3.png)

4. Configuració del lloc web:

    ![Configuració del lloc web](../figures/wordpress-mono/wp4.png)

    on:

    * **Site Title**: Títol del lloc.
    * **Username**: Nom d'usuari per accedir al panell d'administració.
    * **Password**: Contrasenya per accedir al panell d'administració.
    * **Your Email**: Correu electrònic per a la recuperació de la contrasenya.

    Un cop hàgiu introduït aquesta informació, podeu continuar amb el procés d'instal·lació de WordPress. Després d'instal·lar amb èxit WordPress, podreu iniciar la sessió al panell d'administració amb el nom d'usuari i la contrasenya que heu triat i començar a personalitzar i gestionar el vostre lloc web.
  
5. Inicia sessió amb les credencials creades:

    ![Inicia sessió](../figures/wordpress-mono/wp5.png)

6. Panell d'administració:

    ![Panell d'administració](../figures/wordpress-mono/wp6.png)

7. Visualització del lloc web:

    ![Panell d'administració](../figures/wordpress-mono/wp7.png)

En aquest punt tenim 2 accessos al nostre servidor web. Un és el panell d'administració de **WordPress** i l'altre és el lloc web en si mateix:

* **Panell d'administració**: [http://ip/wordpress/wp-admin/](http://ip/wordpress/wp-admin/)
* **Lloc web**: [http://ip/wordpress/](http://ip/wordpress/)

On *ip* és la ip del vostre servidor o el vostre nom de domini si teniu un configurat.
