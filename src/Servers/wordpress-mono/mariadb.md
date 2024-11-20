# Instal·lant i configurant MariaDB

Per poder utilitzar el Wordpress necessitem d'una base de dades del tipus MariaDB (MySQL). El primer pas es revisar si el paquet **mariadb** està disponible amb la versió correcta. 

Instal·lació:

1. Instal·lem el paquet **mariadb**:

    ```sh
    # apt install mariadb-server 
    ```

2. Iniciem el servei de MariaDB:

    ```sh
    # systemctl start mariadb
    ```

3. Comprovem l'estat del servei:

    ```sh
    # systemctl status mariadb
    ```

4. Habilitar el servei per iniciar cada cop que el sistema arranqui:

    ```sh
    # systemctl enable mariadb
    ```

5. Inicieu sessió a MariaDB:

    ```sh
    # mysql -u root -p
    ```

6. Creeu una base de dades per a Wordpress:

    ```sql
    CREATE DATABASE wordpress_db;
    ```

7. Creeu l'usuari per a la base de dades:

    ```sql
    CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'password';
    ````

    * **wordpress_user**: Nom de l'usuari de la base de dades.
    * **password**: Contrasenya de l'usuari de la base de dades.
    * **localhost**: Nom de l'amfitrió on es connectarà l'usuari.
  
    En aquest cas, heu de substituir **wordpress_user** i **password** pels valors que vulgueu utilitzar. 
    
    Per exemple:
    
    ```bash
    # hostname
    debian
    ```

    ```sql
    CREATE USER 'francesc'@'debian' IDENTIFIED BY 'amsa';
    ````

8. Atorgueu tots els permisos a l'usuari per a la base de dades:

    ```sql
    GRANT ALL ON wordpress_db.* TO 'francesc'@'debian';
    ```
    Aquesta comanda atorga tots els permisos de la base de dades **wordpress_db** a l'usuari **francesc** al host **debia**.

9. Actualitzeu els permisos:

    ```sql
    FLUSH PRIVILEGES;
    ```

10. Sortiu de MariaDB:

    ```sql
    EXIT;
    ```
