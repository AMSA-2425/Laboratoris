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
    MariaDB[(none)]>
    ```

6. Creeu una base de dades per a Wordpress:

    ```sql
    MariaDB[(none)]> CREATE DATABASE wordpress_db;
    ```

7. Canvieu a la BBDD `wordpress_db`:

    ```sql
    MariaDB[(none)]> USE wordpress_db;
    MariaDB[(wordpress_db)]> 
    ````

8. Creeu l'usuari amb permisos d'accés per a la base de dades:

    ```sql
    MariaDB[(wordpress_db)]> CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'password';
    ````

    * **wordpress_user**: Nom de l'usuari de la base de dades (francesc).
    * **password**: Contrasenya de l'usuari de la base de dades (amsa).
    * **localhost**: Nom de l'amfitrió on es connectarà l'usuari.
  
    En aquest cas, heu de substituir **wordpress_user** i **password** pels valors que vulgueu utilitzar. 
    
    Per exemple:

    ```sql
    MariaDB[(wordpress_db)]> CREATE USER 'francesc'@'localhost' IDENTIFIED BY 'amsa';
    ````

   Si volem accedir a la BBDD des de un host `debian-1`, posarem:
   
    ```sql
    MariaDB[(wordpress_db)]> CREATE USER 'francesc'@'debian-1' IDENTIFIED BY 'password';
    ````
   
   Si volem accedir a la BBDD des d'un host am IP `192.168.64.11`, posarem:
   
    ```sql
    MariaDB[(wordpress_db)]> CREATE USER 'francesc'@'192.168.64.11' IDENTIFIED BY 'password';
    ````
    
   Si volem accedir a la BBDD des de qualsevol host, posarem:
   
    ```sql
    MariaDB[(wordpress_db)]> CREATE USER 'francesc'@'%' IDENTIFIED BY 'password';
    ````
 
  
9. Atorgueu tots els permisos a l'usuari `francesc`per accedir a la base de dades:

    ```sql
    MariaDB[(wordpress_db)]> GRANT ALL ON wordpress_db.* TO 'francesc'@'localhost';
    ```
    Aquesta comanda atorga tots els permisos de la base de dades **wordpress_db** a l'usuari **francesc** al host **localhost**.

10. Actualitzeu els permisos:

	```sql
	MariaDB[(wordpress_db)]>  FLUSH PRIVILEGES;
	```

11. Sortiu de MariaDB:

	```sql
	MariaDB[(wordpress_db)]> EXIT;
	```
 
 12. Per entrar a MariaDB a la BBDD wordpress_db:
 
	 ```sql
	 # mysql -u root -p wordpress_db
	 MariaDB[(wordpress_db)]>
	 ```
 
 
    
 **NOTA**: les comandes SQL també són vàides en minúscules.
