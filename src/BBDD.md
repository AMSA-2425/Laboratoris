# BBDD (Bases de Dades)

 En aquest tema veurem els pricipals gestors de BBDD (Bases de Dades):
 
• MySQL
 
• Postgress

## Instal·lació

• Mysql:

```bash
# apt-get install mysql-server-4.1 mysql-client-4.1 mysql-doc
```

• Postgres: 

```bash
# apt-get install  postgresql postgresql-client postgresql-doc
```

##  Mysql 

• Creació d'una base de dades (llibres):

```bash
# mysqladmin create llibres
```

La b.d. es crea (amb usuari i grup propietari mysql) en  `/var/lib/mysql/llibres`


• Eliminació d'una base de dades (llibres):

```bash
# mysqladmin drop llibres -p
```

La b.d. /var/lib/mysql/llibres s'elimina

• Per entrar en la consola mysql:

```bash
# mysql

mysql>
```

• Sel·lecció de la b.d. llibres:

```sql
mysql> USE llibres; 
```

• Creació de la taula llibre en la b.d. llibres (SQL):

```sql
mysql> CREATE TABLE llibre (Nom VARCHAR(30), Titol VARCHAR(40), Editorial VARCHAR(30));
```

• Per veure el format de la taula llibre (SQL):

```sql
mysql> DESCRIBE llibre; 
|-----------|--------------|------|-----|---------|-------|
| Field     | Type         | Null | Key | Default | Extra |
|-----------|--------------|------|-----|---------|-------|
| Nom       | varchar(30)  | YES  |     | NULL    |       |
| Titol     | varchar(40)  | YES  |     | NULL    |       |
| Editorial | varchar(30)  | YES  |     | NULL    |       |
|-----------|--------------|------|-----|---------|-------|
```

• Inserint un registre en la taula llibre (SQL):

```sql
mysql> INSERT INTO llibre VALUES ('Joan','Apunts Algebra','2002');
```

## Postgress

• Creació d'una base de dades (llibres):

```bash
$ su postgres 

Password:

bash-2.05b$ createdb llibres
```

La b.d. es crea (amb usuari i grup propietari postgres) en `/var/lib/postgres/data/base`

• Eliminació d'una base de dades (llibres):

```bash
$ su postgres 

bash-2.05b$ dropdb llibres
```

La b.d. es borra del directori `/var/lib/pgsql/data/base`

• Per entrar en la consola postgres:

```bash
$ su postgres 

bash-2.05b$ psql template1

- - - - - - - - - - - - - - - - - - - - - - - - - 

template1=#
```


• Selecció de la b.d. llibres:

```sql
template1=# \c llibres
You are now connected to database llibres. 
llibres>
```

• Entrant en la consola i selecció de la b.d. llibres:

```sql
bash-2.05b$ psql llibres
- - - - - - - - - - - - - - - - - - - - - - - - - 
llibres>
```

• Creació de la taula llibre en la b.d. llibres (SQL):

```sql
llibres> CREATE TABLE llibre (Nom VARCHAR(30), Titol VARCHAR(40), Editorial VARCHAR(30));
```


• Per veure el format de la taula llibre:

```sql
llibres> \d llibre 

      Table "public.llibre" 

|-----------|-------------|-----------|
| Column    | Type        | Modifiers |
|-----------|-------------|-----------|
| nom       | varchar(30) |           |
| titol     | varchar(40) |           |
| editorial | varchar(30) |           |
|-----------|-------------|-----------|
```

• Inserint un registre en la taula llibre (SQL):

```sql
llibres> INSERT INTO llibre VALUES ('Joan','Apunts Algebra','2002');
```

## Altres ordres SQL (mysql i Postgres)


• Per veure tot el contingut de la taula llibre:

```sql
llibres> SELECT * FROM llibre;
|------|----------------|-----------|
| nom  | titol          | editorial |
|------|----------------|-----------|
| Joan | Apunts Algebra | 2002      |
|------|----------------|-----------|
```


• Per veure els camps nom i titol de la taula llibre:

```sql
llibres> SELECT nom,titol FROM llibre;
|------|----------------|
| nom  | titol          |
|------|----------------|
| Joan | Apunts Algebra |
|------|----------------|
```

• Per veure totes les BBDD:

 ```sql
llibres> SHOW DATABASES;
|------|----------------|
| Database              |
|------|----------------|
| llibres               |
|------|----------------|
```

• Per veure tots els usuaris:

d'un host: 

 ```sql
 llibres>  SELECT USER,'194.168.64.15' FROM mysql.user;
 ```
 o bé tots els usuaris

 ```sql
 llibres>  SELECT USER FROM mysql.user;
 ```

• Per esborrar un usuari:

 ```sql
 llibres>  DROP USER 'amsa'@'194.168.64.15';
 ```
 
• Les sentències SQL serveixen tant per MySQL com Postgres


## Connexió a un BBDD MySQL remota mitjançant ssh

1. Entrem en MySQL, creem un usuari `amsa`al qual assignarem la IP de la maquina
virtual que fa de client (`192.168.64.13`) i li donem tots els permisos:

	```sql
	# mysql
	mysql> CREATE USER 'amsa'@'192.168.64.15' IDENTIFIED BY '1234';
	mysql> GRANT ALL ON *.* TO 'amsa'@'192.168.64.15';
	mysql>  FLUSH PRIVILEGES;
	```

2. Permetem connexions al port 3306 (per defecte de MySQL) des de la IP de la màquina client:
	
	```bash
	# sbin/iptables -A INPUT -p tcp -s 192.168.64.15 --dport 3306 -j ACCEPT
	```

3. Des del client (`192.168.64.15`) fem la connexió remota al servidor (`192.168.64.11`) amb l’usuari que hem creat per aquest fi (`amsa`), introduim la contrasenya (`1234`):

	```bash
	# mysql -u amsa -h 192.168.64.15 -p
	> 1234
	```

4. Entraria'm a la BBDD:

	```sql
	mysql>
	```
