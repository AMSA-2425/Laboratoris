# Instal·lant i configurant MariaDB

Per poder utilitzar el Wordpress necessitem d'una base de dades del tipus MariaDB o MySQL. El primer pas es revisar si el paquet **mariadb** està disponible amb la versió correcta. 

```sh
dnf search mariadb 
```

```sh
dnf info mariadb
```

```text
Name         : mariadb
Epoch        : 3
Version      : 10.5.22
Release      : 1.el9_2.alma.1
Architecture : aarch64
Size         : 18 M
Source       : mariadb-10.5.22-1.el9_2.alma.1.src.rpm
Repository   : @System
From repo    : appstream
Summary      : A very fast and robust SQL database server
URL          : http://mariadb.org
License      : GPLv2 and LGPLv2
Description  : MariaDB is a community developed fork from MySQL - a multi-user, multi-threaded
             : SQL database server. It is a client/server implementation consisting of
             : a server daemon (mariadbd) and many different client programs and libraries.
             : The base package contains the standard MariaDB/MySQL client programs and
             : utilities.
```

1. Instal·lem el paquet **mariadb**:

    ```sh
    dnf install mariadb-server mariadb -y
    ```

2. Iniciem el servei de MariaDB:

    ```sh
    systemctl enable --now mariadb
    ```

3. Comprovem l'estat del servei:

    ```sh
    systemctl status mariadb
    ```

4. Configurem MariaDB:

    ```sh
    mysql_secure_installation
    1. Enter current password for root (enter for none): 
    2. Switch to unix_socket authentication [Y/n] n
    3. Set root password? Y
    4. New password: xxxxxxx
    5. Remove anonymous users? Y
    6. Disallow root login remotely? Y
    7. Remove test database and access to it? Y
    8. Reload privilege tables now? Y
    ```

    on:

    * **Enter current password for root (enter for none)**: En aquest punt, si és la primera vegada que configureu MariaDB, premeu simplement Enter, ja que encara no hi ha contrasenya establerta per a l'usuari **root**.
    * **Switch to unix_socket authentication [Y/n]**: En aquest punt, respongueu **n** per desactivar l'autenticació de l'usuari **root** a través de unix_socket. Si respongueu **Y**, l'autenticació de l'usuari **root** es farà a través del sistema de fitxers, aquesta opció permet autenticacions avançades que veurem més endavant.
    * **Set root password? (Y/n)**: Respongueu **Y** per indicar que voleu establir una contrasenya per a l'usuari **root** de MariaDB. A continuació, introduïu la nova contrasenya quan se us demani. (per exemple: 1234).
    * **Remove anonymous users? (Y/n)**: Respongueu **Y** per eliminar els usuaris anònims. Això millora la seguretat del sistema, ja que no permet connexions no autenticades.
    * **Disallow root login remotely? (Y/n)**: Respongueu **Y** per desactivar l'inici de sessió remot per a l'usuari **root**. Això significa que l'usuari **root** només podrà iniciar sessió des de la màquina local.
    * **Remove test database and access to it? (Y/n)**: Respongueu **Y** per eliminar la base de dades de proves i l'accés a ella. Això elimina les bases de dades i els usuaris de prova, augmentant encara més la seguretat.
    * **Reload privilege tables now? (Y/n)**: Respongueu **Y** per recarregar les taules de privilegis de MariaDB. Això assegura que els canvis de configuració es facin efectius de seguida.

5. Inicieu sessió a MariaDB:

    ```sh
    mysql -u root -p
    ```

6. Creeu una base de dades per a Wordpress:

    ```sql
    CREATE DATABASE wordpress_db;
    ```

7. Creeu un usuari per a la base de dades:

    ```sql
    CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'password';
    ````

    * **wordpress_user**: Nom de l'usuari de la base de dades.
    * **password**: Contrasenya de l'usuari de la base de dades.
    * **localhost**: Nom de l'amfitrió on es connectarà l'usuari.
  
    En aquest cas, heu de substituir **wordpress_user** i **password** pels valors que vulgueu utilitzar.

8. Atorgueu tots els permisos a l'usuari per a la base de dades:

    ```sql
    GRANT ALL ON wordpress_db.* TO 'wordpress_user'@'localhost';
    ```

    * **wordpress_db**: Nom de la base de dades.
    * **wordpress_user**: Nom de l'usuari de la base de dades.
    * **localhost**: Nom de l'amfitrió on es connectarà l'usuari.
  
    Aquesta comanda atorga tots els permisos de la base de dades **wordpress_db** a l'usuari **wordpress_user**.

9. Actualitzeu els permisos:

    ```sql
    FLUSH PRIVILEGES;
    ```

10. Sortiu de MariaDB:

    ```sql
    EXIT;
    ```

Aquesta configuració de MariaDB és suficient per a la instal·lació de Wordpress. S'han adaptat els passos de la documentació oficial [https://developer.wordpress.org/advanced-administration/before-install/creating-database/](https://developer.wordpress.org/advanced-administration/before-install/creating-database/).
