# Docker

Fins ara, hem explorat com els administradors de sistemes poden utilitzar la virtualització per crear entorns aïllats i segurs per a les aplicacions. Hem après a crear màquines virtuals, xarxes virtuals i emmagatzematge virtual, comprenent com aquestes tecnologies són útils per desenvolupar entorns de desenvolupament i producció robustos. També hem posat de manifest que la virtualització és una eina fonamental per a la creació de datacenters i la implementació de tecnologies de núvol. En aquesta secció, ens aprofundirem en una evolució significativa: la virtualització mitjançant contenidors.

Els **contenidors**, a diferència de les **màquines virtuals**, ofereixen una aproximació més lleugera i eficient a la virtualització. El concepte de contenidor implica la virtualització d'un entorn amb només el programari necessari per a executar una aplicació específica. Considerem, per exemple, la necessitat d'executar programes en *Python 2* i *Python 3* en el mateix sistema. En lloc de crear una màquina virtual, configurar-la i instal·lar *Python 2* i *Python 3*, podem crear dos contenidors separats, un per a cada versió de Python. Aquests contenidors no contenen un sistema operatiu complet; només integren les llibreries i dependències imprescindibles per a executar *Python 2* i *Python 3*.

**Quantes vegades us ha passat que heu fet un desenvolupament ho heu testat a la vostra màquina i quan l'heu passat a producció no ha funcionat?** Això és degut a que el vostre entorn de desenvolupament no és igual que l'entorn de producció. Amb els contenidors podem crear un entorn de desenvolupament idèntic a l'entorn de producció, de manera que el que funciona en un entorn també funcionarà en l'altre.

A més a més, penseu que els sistemes canvien constantment. **Quantes vegades heu hagut de canviar de sistema operatiu i heu hagut de tornar a configurar tots els vostres programes?** Amb els contenidors podem crear un contenidor amb tots els nostres programes i configuracions i executar-lo en qualsevol sistema operatiu que vulguem.

Les diferències principals entre les màquines virtuals i els contenidors es detallen a continuació:

| Característiques              | Màquines Virtuals (MV)                           | Contenidors                                   |
|-------------------------------|--------------------------------------------------|-----------------------------------------------|
| **Virtualització**            | Virtualització completa de Hardware.                    | Virtualitza el sistema operatiu i els recursos de l'aplicació.|
| **Pes i Overhead**            | Més pesats i requereixen més recursos.           | Més lleugers, amb baix overhead i ràpids d'iniciar.|
| **Aïllament**                | Fort aïllament, com màquines físiques separades. | Aïllament lleuger, comparteixen el mateix nucli del sistema.|
| **Rendiment**                | Potencialment menor rendiment a causa de la virtualització completa. | Major rendiment gràcies a la virtualització de sistema.|
| **Temps d'inici**            | Més llarg per iniciar ja que tot el sistema operatiu s'ha de carregar. | Ràpids d'iniciar ja que només es necessiten els recursos específics de l'aplicació.|
| **Portabilitat**             | Menys portables, ja que poden estar lligats a configuracions de hardware específiques. | Més portables, ja que tots els requisits estan inclosos en el contenidor.|
| **Escalabilitat**            | Menys eficients en termes de recursos en entorns amb múltiples màquines virtuals. | Més eficients, ja que comparteixen recursos amb el sistema host.|
| **Desenvolupament**          | Requereix configuració específica i gestió de dependencies. | Més simple i eficient en el desenvolupament, ja que tot està contingut en el contenidor.|
| **Utilització de Recursos**  | Utilitza més recursos a causa de la virtualització completa. | Utilitza menys recursos, ja que comparteixen moltes de les llibreries amb el sistema host.|

Dins d'aquest àmbit, destaca **Docker**. **Docker** és una eina de virtualització de contenidors que ofereix una plataforma per a crear, distribuir i executar aplicacions en contenidors. **Docker** és una eina de codi obert que utilitza la tecnologia de contenidors Linux per a crear i gestionar contenidors virtuals aïllats en un sistema operatiu. És una eina molt popular i és utilitzada per moltes empreses per a crear i gestionar aplicacions en contenidors.

Amb la seva naturalesa multiplataforma, portabilitat i àmplia adopció, **Docker** s'ha convertit en una eina essencial per als administradors de sistemes moderns.

## Instal·lació de Docker a EC2

Docker està disponible per a molts sistemes operatius, incloent-hi Linux, macOS i Windows. En aquesta secció, instal·larem Docker en un sistema Linux. En concret, instal·larem a Amazon Linux 2023.

- Windows: [https://docs.docker.com/docker-for-windows/install/](https://docs.docker.com/docker-for-windows/install/)
- macOS: [https://docs.docker.com/docker-for-mac/install/](https://docs.docker.com/docker-for-mac/install/)
- Linux: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

### Instal·lació de Docker

Per a instal·lar Docker, seguirem els passos següents:

1. Instal·larem el paquet `docker`:

    ```bash
    sudo yum install docker -y
    ```

2. Activarem i iniciarem el servei de Docker:

    ```bash
    sudo systemctl enable --now docker
    ```

3. Comprovarem que Docker s'ha instal·lat correctament:

    ```bash
    docker version
    ```

4. Per a poder executar comandes de Docker sense necessitat de ser un usuari root, afegirem el nostre usuari al grup `docker`:

    ```bash
    sudo usermod -a -G docker ec2-user
    newgrp docker # Per a aplicar els canvis
    ```

5. Actualitzarem els permissos del socket de Docker per permetre als usuaris del grup docker llegir i escriure:

    ```bash
    sudo chmod g+rw /var/run/docker.sock
    ```

## Imatges i contenidors

Una imatge de **Docker** és un fitxer de lectura que encapsula tots els elements necessaris per executar una aplicació. Aquesta imatge actua com una plantilla utilitzada per crear instàncies específiques conegudes com a contenidors.

Per exemple, en el cas de Python, una imatge de Docker pot contenir el codi font de Python, les llibreries associades i altres dependències requerides per a executar una aplicació Python.

La imatge de Python 3.9 es pot descarregar des del repositori oficial de Docker:

```bash
docker pull python:3.9
```

Aquesta comanda descarrega la imatge de Python 3.9 des del repositori oficial de Docker. Per a comprovar que la imatge s'ha descarregat correctament, podem utilitzar la comanda `docker images`:

```bash
docker images
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
python       3.9       1a2b3c4d5e6f   2 minutes ago   128MB
```

Aquesta comanda llista totes les imatges de Docker al sistema. En aquest cas, només tenim una imatge, la imatge de Python 3.9.

Per poder revisar el dockerfile de la imatge de Python 3.9 podem utilitzar la comanda `docker history`:

```bash
docker history python:3.9 --no-trunc --format "{{.CreatedBy}}"
```

Amb aquesta comanda podem veure tot el que s'ha fet per crear la imatge de Python 3.9.

Un cop tenim la imatge descarregada, podem crear un contenidor a partir d'aquesta imatge. Un contenidor és una instància en execució d'una imatge. És a dir, un contenidor és un procés en execució aïllat del sistema host que utilitza els recursos de la imatge per a executar una aplicació. Per tant, podem crear múltiples contenidors a partir de la mateixa imatge.Per a crear un contenidor, utilitzarem la comanda `docker run` amb la següent sintaxi:

```bash
docker run <nom_imatge> <ordre>
```

Per exemple, podem crear un contenidor a partir de la imatge `python:3.9` i executar la comanda `python --version` dins del contenidor:

```bash
docker run python:3.9 python --version
```

Aquesta comanda crea un contenidor a partir de la imatge `python:3.9` i executa la comanda `python --version` dins del contenidor. Aquesta comanda mostra la versió de Python que s'està executant dins del contenidor.

```bash
docker run python:3.9 python -c "s = 'Hola món'; print(s)"
```

Aquesta comanda crea un contenidor a partir de la imatge `python:3.9` i executa la comanda `python -c "s = 'Hola món'; print(s)"` dins del contenidor. Aquesta comanda mostra el text "Hola món" a la consola.

Després d'executar aquestes comandes, el contenidor s'atura de manera automàtica. Ho podem comprovar amb la comanda `docker ps -a`. Però, i **si volem que el contenidor no s'aturi? I poder reaprofitar-lo?**

Per a crear un contenidor que s'executi en segon pla, utilitzarem l'opció **-d** i afegirem l'opció **-i** per a executar la comanda en mode interactiu (stdin). D'aquesta manera, el contenidor no s'aturarà fins que no l'aturarem manualment.

```bash
docker run -d -i python:3.9
```

Per poder executar comandes dins del contenidor que acabem de crear, necessitarem el seu identificador (**CONTAINER ID**). Amb aquest identificador, utilitzarem la comanda `docker exec` per a executar comandes dins del contenidor:

```bash
docker exec -it <CONTAINER ID> <ordre>
# En el meu cas el CONTAINER ID és dbd2498d3f1c
docker exec -it dbd2498d3f1c python -c "s = 'Hola món'; print(s)"
docker exec -it dbd2498d3f1c python --version
```

D'aquesta manera, tenim un contenidor en segon pla que no s'atura i podem executar comandes dins del seu entorn.
Per a aturar el contenidor, utilitzarem la comanda `docker stop`:

```bash
docker stop <CONTAINER ID>
# En el meu cas el CONTAINER ID és dbd2498d3f1c
docker stop dbd2498d3f1c
```

Per a eliminar el contenidor, utilitzarem la comanda `docker rm`:

```bash
docker rm <CONTAINER ID>
# En el meu cas el CONTAINER ID és dbd2498d3f1c
docker rm dbd2498d3f1c
```

> NOTA: Podeu tenir múltiples contenidors a partir de la mateixa imatge. Amb noms de contenidors diferents.

```bash
docker run -di --name python-app-1 python:3.9
docker run -di --name python-app-2 python:3.9
```

Per aturar i eliminar tots els contenidors, utilitzarem les comandes `docker stop` i `docker rm` amb la següent sintaxi:

```bash
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
```

### Personalitzant imatges amb Dockerfile

Una imatge és immutable, però es poden afegir capes per crear noves versions en funció de les necessitats. Per exemple, si necessitem instal·lar una llibreria específica, podem crear una nova imatge que contingui aquesta llibreria. Aquesta imatge es basarà en la imatge original, però amb una nova capa que conté la llibreria que volem instal·lar.

```bash
docker run python:3.9 python -c "import numpy as np; print(np.random.rand())"
# ModuleNotFoundError: No module named 'numpy'
```

Per a crear una nova imatge, utilitzarem un fitxer anomenat **Dockerfile**. Aquest fitxer conté les instruccions per a crear una imatge de Docker. A continuació, es mostra un exemple de Dockerfile:

```dockerfile
# Dockerfile
FROM python:3.9
RUN pip install numpy
```

En aquest exemple, la primera línia indica que la imatge es basa en una versió específica de Python (3.9). La segona línia executa la comanda `pip install` per instal·lar la llibreria NumPy. Per a crear una imatge de Docker, utilitzarem la comanda `docker build` amb la següent sintaxi:

```bash
docker build -t <nom_imatge> <directori>
```

Per crea una imatge de Docker amb el nom `python-app`:

```bash
mkdir python-app
cd python-app
cat << EOF > Dockerfile
FROM python:3.9
RUN pip install numpy
EOF
docker build -t python-app .
cd ..
```

Per utilitzar la imatge que acabem de crear, utilitzarem la comanda `docker run` amb la següent sintaxi:

```bash
docker run python-app python -c "import numpy as np; print(np.random.rand())"
```

### Compartint dades entre el sistema host i els contenidors

Els contenidors i el sistema host en principi estan aïllats. Però, **i si volem compartir dades entre el sistema host i els contenidors?** Però i si vull executar un script de Python que està al meu sistema host dins del contenidor? 

Per exemple:

```bash
mkdir python-project
cd python-project
cat << EOF > hola.py
print("Hola món!")
EOF
```

Si intentem executar el fitxer `hola.py` dins del contenidor, obtindrem un error:

```bash
docker run python:3.9 python hola.py
# python: can't open file '//hola.py': [Errno 2] No such file or directory
```

Això és degut a que el fitxer `hola.py` no existeix dins del contenidor. Per a solucionar aquest problema, utilitzarem l'opció **-v** per a vincular un fitxer o directori des del sistema host al contenidor:

```bash
docker run -v $(pwd):/app python:3.9 python /app/hola.py
```

Aquesta comanda vincula el directori actual al directori `/app` del contenidor. D'aquesta manera, podem executar el fitxer `hola.py` dins del contenidor.

**Què passa si ara el script python esciu un fitxer de sortida?** Si el fitxer de sortida es crea dins del directori `/app` del contenidor, com el tenim vinculat al directori actual del sistema host, el fitxer de sortida també es crearà en el sistema host. Això és molt útil per a compartir dades entre el sistema host i els contenidors.

```bash
cat << EOF > hola2.py
output = open("/app/sortida.txt", "w")
output.write("Hola món!")
output.close()
EOF
```

```bash
docker run -v $(pwd):/app python:3.9 python /app/hola2.py
```

Si comprovem el directori actual, veurem que s'ha creat el fitxer `sortida.txt`:

```bash
ls
# hola.py  hola2.py  sortida.txt
```

En canvi, si fem el mateix però sense vincular el directori actual al directori `/app` del contenidor, el fitxer `sortida.txt` es crearà dins del contenidor i no es compartirà amb el sistema host:

```bash
rm sortida.txt
docker run python:3.9 python /app/hola2.py
ls
# hola.py  hola2.py
```

### Accedint a un contenidor

Hem vist que els contenidors estan aïllats del sistema host però els podem executar en segon pla i executar comandes dins del seu entorn. Però, **i si volem accedir al seu entorn?** Per exemple, **i si volem accedir a la consola del contenidor?**

```bash
docker run -it python:3.9 bash
```

Observem que la consola ha canviat. Això és degut a que ara estem dins del contenidor. Podem comprovar-ho executant la comanda `python --version`:

```bash
python --version
# Python 3.9.7
```

Per a sortir del contenidor, utilitzarem la comanda `exit`:

```bash
exit
```

Si volem accedir a un contenidor que està en segon pla, utilitzarem la comanda `docker exec` amb la següent sintaxi:

```bash
docker exec -it <nom_contenidor> <ordre>
# En el meu cas el nom del contenidor cranky_bhabha
docker exec -it cranky_bhabha bash
```

### Cheat Sheet

| Comanda                                  | Descripció                                              |
|------------------------------------------|---------------------------------------------------------|
| `docker build -t <nom_imatge> <directori>` | Construeix una imatge de Docker a partir d'un Dockerfile al directori especificat. |
| `docker images`                          | Llista totes les imatges de Docker al sistema.          |
| `docker run -d --name <nom_contenidor> -p <port_host>:<port_contenidor> <nom_imatge>` | Crea i executa un nou contenidor a partir d'una imatge de Docker. |
| `docker ps`                              | Llista tots els contenidors en execució.                |
| `docker stop <nom_contenidor>`           | Atura un contenidor en execució.                        |
| `docker rm <nom_contenidor>`             | Elimina un contenidor.                                  |
| `docker rmi <nom_imatge>`                | Elimina una imatge.                                     |
| `docker exec -it <nom_contenidor> <ordre>` | Executa una comanda a l'interior d'un contenidor en execució. |
| `docker logs <nom_contenidor>`           | Mostra els registres (logs) d'un contenidor.            |
| `docker inspect <nom_contenidor>`        | Mostra informació detallada d'un contenidor.            |


## Emmagatzematge

En el món de Docker, és essencial comprendre com gestionar les dades emmagatzemades pels contenidors, ja que aquests són efímers de manera predeterminada. Les imatges de Docker estan compostes per capes de lectura, i quan s'executa un contenidor, es crea una nova capa d'escriptura temporal. No es persisteixen canvis en aquesta capa d'escriptura, i quan el contenidor es deté o s'elimina, tots els canvis es perden Aquest comportament presenta alguns reptes:

- Com es poden persistir les dades?
- Com es poden compartir entre contenidors?
- Com es poden compartir entre el sistema host i els contenidors?

### Volums

Els volums són la manera recomanada de persistir dades generades o utilitzades pels contenidors de Docker, especialment quan la càrrega de treball implica un gran volum de dades, com ara en el cas de bases de dades. Utilitzant volums, les dades persisteixen més enllà del cicle de vida d'un contenidor. Imagineu que tenim un contenidor que executa una base de dades. Si aquest contenidor es deté o s'elimina, les dades de la base de dades es perdran. Per a evitar aquest problema, podem utilitzar volums per a persistir les dades de la base de dades.

#### Configurant un contenidor per una base de dades no relacional

En aquesta secció, configurarem un contenidor per a una base de dades no relacional. Utilitzarem MongoDB, una base de dades no relacional orientada a documents. MongoDB és una base de dades molt popular i és utilitzada per moltes empreses per a crear i gestionar bases de dades no relacionals.

Per a configurar un contenidor per a MongoDB, seguirem els passos següents:

1. Crearem un directori per a guardar les dades de la base de dades:

    ```bash
    mkdir -p /opt/mongodb/data
    ```

2. Crearem un contenidor per a MongoDB:

    ```bash
    docker run -d --name mongodb \
        -p 27017:27017 \
        -v /opt/mongodb/data:/data/db \
        mongo:4
    ```

    Estem creant un contenidor anomenat `mongodb` a partir de la imatge `mongo` a la versió 4. Aquest contenidor s'està executant en segon pla (**-d**) i s'està vinculant el port 27017 del sistema host al port 27017 del contenidor (**-p 27017:27017**). A més a més, s'està creant un volum anomenat `/opt/mongodb/data` i s'està vinculant al directori `/data/db` del contenidor (**-v /opt/mongodb/data:/data/db**). Això permetrà que les dades de la base de dades es guardin al sistema host i no es perdran quan el contenidor es deté o s'elimina.

3. Comprovarem que el contenidor s'està executant:

    ```bash
    docker ps
    # CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                           NAMES
    # e4c8a84be889   mongo:4   "docker-entrypoint.s…"   7 seconds ago   Up 4 seconds   0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   mongodb
    ```

4. Comprovarem que la base de dades està en execució:

    ```bash
    docker exec -it mongodb mongo
    ```

    Observem que la consola ha canviat. Això és degut a que ara estem dins del contenidor, concretament de la base de dades mongo. Podem comprovar-ho executant la comanda `db.version()`:

    ```bash
    > db.version()
    # 4.4.26
    ```

5. Crearem una base de dades i inserirem un document:

    ```bash
    > use testdb
    # switched to db testdb
    > db.test.insert({name: "test"})
    # WriteResult({ "nInserted" : 1 })
    ```

6. Comprovarem que el document s'ha inserit correctament:

    ```bash
    > db.test.find()
    # { "_id" : ObjectId("5f5f5f5f5f5f5f5f5f5f5f5f"), "name" : "test" }
    ```

7. Sortirem de la consola de MongoDB:

    ```bash
    > exit
    ```

En aquesta configuració el servei MongoDB és gestionat per un contenidor però les dades són persistents gràcies al volum que hem creat. Això ens permetrà aturar i eliminar el contenidor sense perdre les dades. 

- Per a comprovar-ho, aturem i eliminem el contenidor:

    ```bash
    docker stop mongodb
    docker rm mongodb
    ```

- Ara, tornem a crear el contenidor:

    ```bash
    docker run -d --name mongodb \
        -p 27017:27017 \
        -v /opt/mongodb/data:/data/db \
        mongo:4
    ```

- I comprovem que la base de dades i el document encara existeixen:

    ```bash
    docker exec -it mongodb mongo
    > use testdb
    > db.test.find()
    # { "_id" : ObjectId("5f5f5f5f5f5f5f5f5f5f5f5f"), "name" : "test" }
    > exit
    ```

- També podeu observer el contingut del host:

    ```bash
    ls -la /opt/mongodb/data
    ```

Els vincles ofereixen una altra opció per accedir a fitxers del sistema host des dins d'un contenidor. Aquesta opció és especialment útil quan necessitem accedir a fitxers específics del sistema host, com ara sistemes de fitxers compartits.

Per exemple, en el cas de la base de dades MongoDB, podem tenir vincles a fitxers de configuració específics del sistema host. Això ens permetrà configurar la base de dades des del sistema host.

```bash
docker run -d --name mongodb \
    -p 27017:27017 \
    -v /opt/mongodb/data:/data/db \
    -v /path/to/mongo.conf:/etc/mongo.conf \
    mongo:4 --config /etc/mongo.conf
```

El ftixer `/path/to/mongo.conf` conté la configuració de MongoDB. Aquest fitxer es troba al sistema host i es vincula al contenidor. Això permet que el fitxer de configuració es mantingui al sistema host i no es perdi quan el contenidor es deté o s'elimina.

### Controladors d'emmagatzematge

Els controladors d'emmagatzematge es fan servir per emmagatzemar les diferents capes i per desar dades a la capa d'escriptura d'un contenidor. En general, els controladors d'emmagatzematge estan implementats amb l'objectiu d'optimitzar l'ús d'espai, però la velocitat d'escriptura pot ser més baixa que el rendiment del sistema de fitxers, depenent del controlador que s'estigui utilitzant. Per defecte s'utiltiza el controlador anomenat **overlay2**, el qual està basat en *OverlayFS*.

Per a comprovar quin controlador d'emmagatzematge s'està utilitzant, utilitzarem la comanda `docker info`:

```bash
docker info | grep Storage
# Storage Driver: overlay2
```

Per a canviar el controlador d'emmagatzematge, utilitzarem la comanda `dockerd` amb la següent sintaxi:

```bash
dockerd --storage-driver <controlador>
```

Existeixen diferents controladors d'emmagatzematge. A continuació, es mostra una llista dels controladors d'emmagatzematge més utilitzats:

|  | Overlay2 | ZFS | Btrfs | Device Mapper | VFS |
| ---------------------------- | -------- | --- | ----- | ------------- | --- |
| Suport per Còpia d'Esriptura (Copy-on-Write) | Sí       | Sí   | Sí    | Sí            | No  |
| Rendiment d'Esriptura | Mitjà/Alt | Alt | Alt   | Mitjà/Alt     | Baix |
| Optimització d'Espai | Sí       | Sí   | Sí    | Sí            | No  |
| Suport de Volums | Sí       | Sí   | Sí    | Sí            | Sí  |
| Compatibilitat (amb altres sistemes de fitxers) | Bona | Bona | Bona   | Bona          | Excel·lent |
| Velocitat de Llegir (Read Speed) | Alta    | Molt Alta | Alta | Mitjà/Alta     | Alta |
| Suport a Instantànies (Snapshots) | No | Sí | No  | Sí          | No  |
| Compressió i Deduplicació | No | Sí | No  | Sí          | No  |
| Replicació de Dades | No | Sí | No  | Sí          | No  |
| Recomanat per a Producció | Sí       | Depèn de la configuració | No | Depèn de la configuració | No  |

## Xarxes

Els contenidors de Docker poden utilitzar xarxes per a comunicar-se entre ells. Aquesta comunicació pot ser entre contenidors en el mateix sistema host o entre contenidors en diferents sistemes host. Això permet que els contenidors es comuniquin entre ells i amb el sistema host.

Per defecte, Docker crea una xarxa virtual per a cada contenidor. Aquesta xarxa és privada i només els contenidors que pertanyen a la mateixa xarxa poden comunicar-se entre ells. Aquesta xarxa és creada automàticament per Docker i no es pot eliminar.

Per a crear una xarxa de contenidors, utilitzarem la comanda `docker network create`:

```bash
docker network create my-network
```

Aquesta comanda crea una xarxa de contenidors amb el nom `my-network`. Per a comprovar que la xarxa s'ha creat correctament, podem utilitzar la comanda `docker network ls`:

```bash
docker network ls
NETWORK ID     NAME          DRIVER    SCOPE
1a2b3c4d5e6f   bridge        bridge    local
7a8b9c0d1e2f   host          host      local
3a4b5c6d7e8f   my-network    bridge    local
```

Ara, crearem dos contenidors i els afegirem a la xarxa `my-network`:

```bash
docker run -d --name nginx --network my-network nginx
docker run -d --name apache --network my-network httpd
```

Aquests contenidors s'han creat a partir de les imatges `nginx` i `httpd` i s'han afegit a la xarxa `my-network`. Per a comprovar que els contenidors s'han creat correctament, podem utilitzar la comanda `docker ps`:

```bash
docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                    NAMES
1a2b3c4d5e6f   nginx         "nginx -g 'daemon of…"   2 minutes ago   Up 2 minutes   80/tcp                   nginx
7a8b9c0d1e2f   httpd         "httpd-foreground"       2 minutes ago   Up 2 minutes   80/tcp                   apache
```

Aquesta xarxa és privada i només els contenidors que pertanyen a la mateixa xarxa poden comunicar-se entre ells. Podem comprovar-ho executant la comanda `docker exec`:

```bash
docker exec -it nginx curl http://apache
```

Aquesta comanda executa la comanda `curl` dins del contenidor `nginx` i comprova que pot comunicar-se amb el contenidor `apache`. Ara bé, si fem un `curl` des del sistema host al contenidor `apache` no funcionarà:

```bash
curl http://apache
curl: (6) Could not resolve host: apache
```

Si volem que els contenidors puguin comunicar-se amb el sistema host, hem d'utilitzar l'opció **--publish** o **-p**:

```bash
docker run -d --name nginx --network my-network -p 8080:80 nginx
docker run -d --name apache --network my-network -p 8081:80 httpd
```

Aquesta comanda crea un contenidor a partir de la imatge `nginx` i l'afegeix a la xarxa `my-network`. A més a més, el contenidor està escoltant en el port 80 del sistema host. Si accediu utiltizant un navegador a [http://127.0.0.1:8080](http://127.0.0.1:8080) o [http://127.0.0.1:8081](http://127.0.0.1:8081) observareu que els dos contenidors estan funcionant. Els dos utilitzen el port 80 del seu contenidors, però es mappegen a diferents ports del sistema host.

## Variables d'entorn

Els contenidors de Docker poden utilitzar variables d'entorn per a configurar el seu comportament. Les variables d'entorn són variables dinàmiques que poden afectar el comportament d'un procés en un sistema. Aquestes variables s'utilitzen per a configurar el comportament del procés i són especialment útils per a passar informació a les aplicacions.

Imaginem que volem modificar el comportament d'un procés. Per exemple, volem modificar el comportament d'un procés de Python. Per a fer-ho, podem utilitzar variables d'entorn. A continuació, es mostra un exemple de com utilitzar variables d'entorn per a modificar el comportament d'un procés de Python:

```bash
cat << EOF > hola3.py
import os
print("Hola " + os.environ["NOM"] + "!")
EOF
```

```bash
docker run -v $(pwd):/app --env NOM=Joan python:3.9 python /app/hola3.py
```

## Dockeritzant aplicacions

> OBSERVACIÓ: Una tasca fonamental és dockeritzar les vostres aplicacions. Això us permetrà tenir un entorn de desenvolupament idèntic a l'entorn de producció. A més a més, us permetrà compartir les vostres aplicacions amb altres persones de manera senzilla. Per a més informació, podeu consultar la documentació oficial de Docker: [Dockerfile reference](https://docs.docker.com/engine/reference/builder/).

### Sintaxi de Dockerfile

A continuació, es mostra la sintaxi bàsica d'un Dockerfile:

```dockerfile
# Imatge base que s'utilitzarà com a punt de partida
FROM <nom_imatge>

# Executa una comanda durant la construcció de la imatge
RUN <ordre>

# Defineix una variable d'entorn que pot ser utilitzada durant l'execució del contenidor
ENV <variable_entorn>=<valor>

# Estableix el directori de treball per a les comandes següents
WORKDIR <directori>

# Vincula un fitxer o directori des del sistema host al contenidor
COPY <fitxer|directori> <directori>

# Comanda per defecte que s'executarà quan es crei un contenidor basat en aquesta imatge
CMD ["<ordre>"]

# Etiqueta amb metadades per proporcionar informació addicional
LABEL <clau>=<valor>

# Crea un volum per emmagatzemar dades fora del contenidor
VOLUME <directori>

# Indica quin port exposarà el contenidor (no obre realment el port, només és informatiu)
EXPOSE <port>

# Especifica l'usuari que s'executarà en el contenidor
USER <usuari>

# Punt d'entrada per a l'aplicació. Sobreescriu la comanda CMD
ENTRYPOINT ["<ordre>"]

# Arguments per passar a l'ENTRYPOINT
# (Útil quan vols parametritzar l'entrada a l'aplicació)
ARGS ["<argument1>", "<argument2>"]
```

Imagineu que tenim un projecte de Python amb la següent estructura:

```bash
.
├── main.py
└── requirements.txt
```

on requirements.txt conté les dependències del projecte:

```bash
cat << EOF > requirements.txt
numpy==1.21.2
EOF
```

i main.py conté el codi font de l'aplicació:

```bash
cat << EOF > main.py
import numpy as np
a = np.array([1, 2, 3])
b = np.array([4, 5, 6])
print(a + b)
EOF
```

Per a dockeritzar aquest projecte, crearem un fitxer anomenat **Dockerfile** amb la següent sintaxi:

```dockerfile
FROM python:3.9
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python", "main.py"]
```

En aquest exemple, la primera línia indica que la imatge es basa en una versió específica de Python (3.9). La segona línia copia el codi font de l'aplicació a la imatge. La tercera línia estableix el directori de treball de la imatge. La quarta línia executa la comanda `pip install` per instal·lar les dependències de l'aplicació. Finalment, la cinquena línia executa l'aplicació quan es crea un contenidor.

Ara l'estructura del projecte és la següent:

```bash
.
├── Dockerfile
├── main.py
└── requirements.txt
```

Per a crear una imatge de Docker, utilitzarem la comanda `docker build` amb la següent sintaxi:

```bash
docker build -t <nom_imatge> -f <fitxer> <directori>
# Ens situem al directori que volem dockeritzat
docker build -t python-app -f Dockerfile .
```

Aquesta comanda crea una imatge de Docker amb el nom `python-app` a partir del directori actual. Per verificar que la imatge s'ha creat amb èxit, podem utilitzar la comanda  `docker images`. Per a comprovar que l'aplicació funciona correctament, crearem un contenidor a partir de la imatge `python-app`:

```bash
docker run python-app
# [5 7 9]
```