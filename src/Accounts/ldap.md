# Gestió centralitzada d'usuaris utiltizant LDAP

## Requisits

- Instància EC2 amb una distribució Linux que actuara com a servidor LDAP. En el nostre cas, utilitzarem una instància Amazon Linux 2023 amb les següents característiques:

    - Nom: `OpenLDAP-AMSA-Server`
    - Tipus: `t2.micro`
    - Arquitectura: `x86_64`
    - IP pública: Activada
    - Seguretat: `OpenLDAP-AMSA-Server-SG`
      - Regles d'entrada:
        - SSH: Port 22
        - LDAP: Port 389
        - LDAPS: Port 636
      - Regles de sortida:
        - Totes les connexions

## Servidor LDAP

### Instal·lació d'eines i dependències

Segons el [manual d'instal·lació](https://www.openldap.org/doc/admin26/install.html) necessitem instal·lar un conjunt d'eines:

```config
REQUIRED SOFTWARE
    OpenLDAP Software 2.6.3 requires the following software:
    Base system (libraries and tools):
        Standard C compiler (required)
        Cyrus SASL 2.1.27+ (recommended)
        OpenSSL 1.1.1+ (recommended)
        libevent 2.1.8+ (recommended)
        libargon2 or libsodium (recommended)
        Reentrant POSIX REGEX software (required)
    SLAPD:
        The ARGON2 password hashing module requires either libargon2
        or libsodium
    LLOADD:
        The LLOADD daemon or integrated slapd module requires
        libevent 2.1.8 or later.
    CLIENTS/CONTRIB ware:
        Depends on package.  See per package README.
```

Per tant, instal·lem les eines necessàries:

```bash
sudo dnf install \
cyrus-sasl-devel make libtool autoconf libtool-ltdl-devel \
openssl-devel libdb-devel tar gcc perl perl-devel wget vim -y
```

### Descarregant el paquet d'instal·lació

Descarreguem el paquet d'instal·lació de la pàgina oficial:

```bash
VER="2.6.3"
cd /tmp
wget ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-$VER.tgz
tar xzf openldap-$VER.tgz
cd openldap-$VER
```

### Configuració i instal·lació

1. Configurem el paquet amb les opcions que necessitem:

    ```bash
    ./configure --prefix=/usr --sysconfdir=/etc --disable-static \
    --enable-debug --with-tls=openssl --with-cyrus-sasl --enable-dynamic \
    --enable-crypt --enable-spasswd --enable-slapd --enable-modules \
    --enable-rlookups  --disable-sql  \
    --enable-ppolicy --enable-syslog
    ```

2. Compilem i instal·lem el paquet:

    ```bash
    make depend
    make
    ```

    > **Nota**: S'hauria de fer un make test per assegurar la correcta compilació, però requereix temps i ometrem el pas.

3. Habilitant paquets addicionals **SHA-2**: Per defecte, OpenLDAP utilitza l'algorisme de hash SHA-1 per emmagatzemar les contrasenyes. Aquesta configuració es pot trobar al fitxer de configuració d'OpenLDAP, generalment a la secció de configuració del mòdul de contrasenyes. Aquest modul és  considerat poc segur pel que fa a la seguretat de les contrasenyes, ja que s'han descobert vulnerabilitats que permeten atacs amb èxit. Es recomana utilitzar algorismes més forts com SHA-256, SHA-384 o SHA-512, que ofereixen una millor seguretat.

    ```bash
    cd contrib/slapd-modules/passwd/sha2
    make
    ```

4. Instal·lem els mòduls:

    ```bash
    cd ../../../.. # Tornem a la carpeta inicial
    make install
    ```

5. Instal·lem els mòduls addicionals:

    ```bash
    cd contrib/slapd-modules/passwd/sha2
    make install
    ```

En aquest punt, si tot ha anat bé, ja tindrem el servidor LDAP instal·lat  al nostre servidor. Podeu comprovar:

- Els fitxers de configuració a `/etc/openldap/`:
  
    ```bash
    ls -la /etc/openldap/
    ```

- Les llibreries instal·lades a `/usr/libexec/openldap`:

    ```bash
    ls -la /usr/libexec/openldap
    ```

### Creació d'un usuari/grup per gestionar el dimoni

Es una bona pràctica quan configurem serveis tenir un usuari dedicat i un grup amb permisos restringits per executar aplicacions del sistema. Per tant, anem a fer-ho pel servei LDAP.

En primer lloc crearem el grup amb gid 55 anomenat ldap.

```sh
groupadd -g 55 ldap
```

L'usuari ldap no necessita directori al sistema i el seu directori personal el podem assignar a */var/lib/openldap*. El grup serà l'anterior amb gid 55 i podem assignar el uid 55 a l'usuari ldap. Finalment, podem impedir que aquest usuari inici sessió amb una shell *nologin*.

```sh
useradd -r -M -d /var/lib/openldap -u 55 -g 55 -s /usr/sbin/nologin ldap
```

### Configuració del servei

- Crearem un directori per guardar les dades **/var/lib/openldap**:
  
    ```bash
    mkdir /var/lib/openldap
    ```

- Crearem un directori per guardar la base de dades **/etc/openldap/slapd.d**:

    ```bash
    mkdir /etc/openldap/slapd.d
    ```

- Atorguem els permisos necessaris:

    ```bash
    chown -R ldap:ldap /var/lib/openldap
    chown root:ldap /etc/openldap/slapd.conf
    chmod 640 /etc/openldap/slapd.conf
    ```

- Crearem un fitxer de configuració per el servei LDAP:

    ```bash
    cat > /etc/systemd/system/slapd.service << 'EOL'
    [Unit]
    Description=OpenLDAP Server Daemon
    After=syslog.target network-online.target
    Documentation=man:slapd
    Documentation=man:slapd-mdb

    [Service]
    Type=forking
    PIDFile=/var/lib/openldap/slapd.pid
    Environment="SLAPD_URLS=ldap:/// ldapi:/// ldaps:///"
    Environment="SLAPD_OPTIONS=-F /etc/openldap/slapd.d"
    ExecStart=/usr/libexec/slapd -u ldap -g ldap -h ${SLAPD_URLS} $SLAPD_OPTIONS

    [Install]
    WantedBy=multi-user.target
    EOL
    ```

  - En la primera secció **Unit** indicarem el dimoni del servidor OpenLDAP (*Description=OpenLDAP Server Daemon*) i que ha de ser iniciat després de **syslog.target** i **network-online.target**. 

  - En la segona secció **Service** s'estableix que el servei és de tipus **forking** (és a dir, es farà un ```fork()``` com a procés fill en segon pla), es defineix el fitxer de **PID** (*PIDFile=/var/lib/openldap/slapd.pid*) i es configuren les variables d'entorn per a les URL d'OpenLDAP i les opcions d'OpenLDAP. Finalment, s'especifica la comanda d'inici (**ExecStart**) per a iniciar el dimoni amb les opcions adequades.

  - En la tercera secció **Install** s'indica que el servei ha de ser iniciat en el moment que s'inicia el sistema.

### Genració de contrasenyes amb  SHA-512

Per generar contrasenyes amb l'algorisme de hash SHA-512 (també conegut com a SSHA-512) utilitzant la comanda slappasswd, pots seguir aquests passos:

```sh
slappasswd -h "{SSHA512}" -o module-load=pw-sha2.la -o module-path=/usr/local/libexec/openldap
```

A continuació, la comanda demanarà la nova contrasenya:

```sh
# new password: 1234
# Re-enter new password: 1234
```

Un cop introdueixis la contrasenya, es generarà el hash corresponent amb l'algorisme SHA-512. El resultat hauria de ser similar a això:

```sh
{SSHA512}CBVaUdQC9mVvAi+0O92J3hA+aPdiWUqf4lVr6bGRAUsFJX5aFOEb+1pSsY8PQwW1UKuuCGO2+160HotnfjXIaRKlryVekLnu
```

Aquest és el hash de la contrasenya "1234" generat amb l'algorisme SHA-512.

**Nota**: D'ara en endavant...Si voleu modificar contrasenyes i utiltizar aquesta encriptació heu de seguir aquests passos.

## Crent la base de dades

Notació important: LDAP utilitza una configuració basada en objectes. Cada objecte té una sèrie d'atributs que defineixen les seves característiques.

- Configuració global: Aquesta configuració es troba a la base de dades de configuració, que es troba a la branca `cn=config`. Aquesta base de dades conté la configuració del servidor LDAP, com ara els mòduls carregats, els esquemes, els índexs, etc.
  - **dn**: Distinguished Name: El nom distintiu de l'objecte. És com una adreça única que identifica l'objecte dins de l'estructura de l'arbre LDAP.
  - **objectClass**: Classe d'objecte: Defineix el tipus d'objecte que és.
  - **cn**: Common Name: Nom comú de l'objecte.
  - **olcArgsFile**: Fitxer d'arguments: On es guarden els arguments usats per slapd al iniciar-se.
  - **olcPidFile**: Fitxer PID: On es guarda el PID del procés slapd.
  - **olcTLSCipherSuite**: Llista de xifrats TLS/SSL permesos per a les connexions segures.
  - **olcTLSProtocolMin**: Versió mínima de TLS permesa.
  
- Configuració de mòduls:  Aquesta base de dades conté els mòduls carregats pel servidor LDAP. En el nostre cas, carregarem el mòdul `pw-sha2.la` per a poder utilitzar l'algorisme de hash SHA-512 i el backend `back_mdb.la` per a emmagatzemar les dades en una base de dades de tipus MDB.

- Configuració d'esquemes: Aquesta configuració es troba a la base de dades de configuració, que es troba a la branca `cn=schema,cn=config`. Aquesta base de dades conté els esquemes que defineixen els objectes i atributs que es poden utilitzar a la base de dades.

- Configuració del frontend: Aquesta configuració es troba a la base de dades de configuració, que es troba a la branca `olcDatabase=frontend,cn=config`. Aquesta configuració defineix com s'accedeix a la base de dades. Crearem dos regles:

    - Lectura de l'esquema: Permet a qualsevol usuari llegir l'esquema de la base de dades.
    - Atorgar permisos d'administrador: Permet a l'usuari `gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth` gestionar la base de dades.

Per fer-ho, crearem un fitxer de configuració `slapd.ldif` a `/etc/openldap/` amb el següent contingut:

```bash
mv /etc/openldap/slapd.ldif /etc/openldap/slapd.ldif.default

cat > /etc/openldap/slapd.ldif << 'EOL'
dn: cn=config
objectClass: olcGlobal
cn: config
olcArgsFile: /var/lib/openldap/slapd.args
olcPidFile: /var/lib/openldap/slapd.pid
olcTLSCipherSuite: TLSv1.2:HIGH:!aNULL:!eNULL
olcTLSProtocolMin: 3.3

dn: cn=schema,cn=config
objectClass: olcSchemaConfig
cn: schema

dn: cn=module,cn=config
objectClass: olcModuleList
cn: module
olcModulepath: /usr/libexec/openldap
olcModuleload: back_mdb.la

dn: cn=module,cn=config
objectClass: olcModuleList
cn: module
olcModulepath: /usr/local/libexec/openldap
olcModuleload: pw-sha2.la

include: file:///etc/openldap/schema/core.ldif
include: file:///etc/openldap/schema/cosine.ldif
include: file:///etc/openldap/schema/nis.ldif
include: file:///etc/openldap/schema/inetorgperson.ldif

dn: olcDatabase=frontend,cn=config
objectClass: olcDatabaseConfig
objectClass: olcFrontendConfig
olcDatabase: frontend
olcPasswordHash: {SSHA512}CBVaUdQC9mVvAi+0O92J3hA+aPdiWUqf4lVr6bGRAUsFJX5aFOEb+1pSsY8PQwW1UKuuCGO2+160HotnfjXIaRKlryVekLnu
olcAccess: to dn.base="cn=Subschema" by * read
olcAccess: to *
by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage
by * none

dn: olcDatabase=config,cn=config
objectClass: olcDatabaseConfig
olcDatabase: config
olcRootDN: cn=config
olcAccess: to *
by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage
by * none
EOL
```

En aquest fitxer, definim la configuració del servidor LDAP, com ara la base de dades, el mòdul de contrasenyes, els esquemes i els permisos d'accés.


Un cop creat el fitxer, carreguem la configuració a la base de dades:

```bash
cd /etc/openldap/
slapadd -n 0 -F /etc/openldap/slapd.d -l /etc/openldap/slapd.ldif
chown -R ldap:ldap /etc/openldap/slapd.d
```

> **Nota**: Si es produeix un error, podeu eliminar la base de dades i tornar a carregar la configuració.

Finalment, iniciem el servei LDAP:

```bash
systemctl daemon-reload
systemctl enable --now slapd
```

### Configurant la estructura de la base de dades

Per configurar la base de dades, crearem un fitxer `rootdn.ldif` a `/etc/openldap/` amb el següent contingut:

```bash
BASE="dc=amsa,dc=udl,dc=cat"

echo "...Generating rootdn file"
cat << EOL >> rootdn.ldif
dn: olcDatabase=mdb,cn=config
objectClass: olcDatabaseConfig
objectClass: olcMdbConfig
olcDatabase: mdb
olcDbMaxSize: 42949672960
olcDbDirectory: /var/lib/openldap
olcSuffix: $BASE
olcRootDN: cn=admin,$BASE
olcRootPW: {SSHA512}CBVaUdQC9mVvAi+0O92J3hA+aPdiWUqf4lVr6bGRAUsFJX5aFOEb+1pSsY8PQwW1UKuuCGO2+160HotnfjXIaRKlryVekLnu
olcDbIndex: uid pres,eq
olcDbIndex: cn,sn pres,eq,approx,sub
olcDbIndex: mail pres,eq,sub
olcDbIndex: objectClass pres,eq
olcDbIndex: loginShell pres,eq
olcAccess: to attrs=userPassword,shadowLastChange,shadowExpire
  by self write
  by anonymous auth
  by dn.subtree="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage
  by dn.subtree="ou=system,$BASE" read
  by * none
olcAccess: to dn.subtree="ou=system $BASE"
  by dn.subtree="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage
  by * none
olcAccess: to dn.subtree="$BASE"
  by dn.subtree="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage
  by users read
  by * none
EOL
```

En aquest fitxer estem configurant un usuari admin. Aquest usuari té privilegis elevats i pot realitzar diverses operacions d'administració en el servidor LDAP. Observeu les regles (*oclAcces*). Per defecte, s'utilitza *1234* com a contrasenya, per modificar-la actualitzeu el hash.

Un cop creat el fitxer, carreguem la configuració a la base de dades:

```bash
ldapadd -Y EXTERNAL -H ldapi:/// -f rootdn.ldif
```

Un cop carregada la configuració, ja tindrem la base de dades configurada i l'usuari admin creat. Ara crearem la estructura per guardar usuaris i grups que s'assembli a la que utilitza el sistema Linux per emmagatzemar usuaris i grups.

- **dc=amsa,dc=udl,dc=cat**: Node principal de la jerarquia LDAP.
- **ou=groups,dc=amsa,dc=udl,dc=cat**. Aquesta entrada representa una organització per als grups.
- **ou=users,dc=amsa,dc=udl,dc=cat**. Aquesta entrada representa una organització per als usuaris.
- **ou=system,dc=amsa,dc=udl,dc=cat**: Aquesta entrada representa una organització per al sistema. És comuna en moltes configuracions LDAP.

```bash
BASE="dc=amsa,dc=udl,dc=cat"
DC="amsa"

cat << EOL >> basedn.ldif
dn: $BASE
objectClass: dcObject
objectClass: organization
objectClass: top
o: AMSA
dc: $DC

dn: ou=groups,$BASE
objectClass: organizationalUnit
objectClass: top
ou: groups

dn: ou=users,$BASE
objectClass: organizationalUnit
objectClass: top
ou: users

dn: ou=system,$BASE
objectClass: organizationalUnit
objectClass: top
ou: system
EOL
```

Un cop creat el fitxer, carreguem la configuració a la base de dades:

```bash
ldapadd -Y EXTERNAL -H ldapi:/// -f basedn.ldif
```

### Afegint usuaris i grups

Per crear un usuari dins la jerarquia que has definit, necessitaràs crear una nova entrada d'usuari amb les propietats adequades. Aquí tens un exemple de com fer-ho en format LDIF:

```ldif
dn: uid=johndoe,ou=users,dc=amsa,dc=udl,dc=cat
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: top
cn: John Doe
sn: Doe
uid: johndoe
uidNumber: 1000
gidNumber: 1000
homeDirectory: /home/johndoe
loginShell: /bin/bash
userPassword: {SSHA512}CBVaUdQC9mVvAi+0O92J3hA+aPdiWUqf4lVr6bGRAUsFJX5aFOEb+1pSsY8PQwW1UKuuCGO2+160HotnfjXIaRKlryVekLnu
```

on:

- **dn**: Distinquished Name (DN) de l'usuari, que indica la seva ubicació dins de la jerarquia. En aquest cas, està dins de la branca "ou=users,dc=curs,dc=asv,dc=udl,dc=cat".
- **objectClass**: Indica les classes d'objectes a les quals pertany aquesta entrada. En aquest cas, pertany a les classes inetOrgPerson, posixAccount, shadowAccount i top, que defineixen les propietats i característiques de l'usuari.
- **cn**: El nom complert de l'usuari, en aquest cas "John Doe".
- **sn**: El cognom de l'usuari, en aquest cas "Doe".
- **uid**: L'identificador únic de l'usuari.
- **uidNumber**: L'identificador únic de l'usuari en termes numèrics.
- **gidNumber**: L'identificador únic del grup al qual pertany l'usuari en termes numèrics.
- **homeDirectory**: La carpeta d'inici de l'usuari.
- **loginShell**: L'intèrpret de comandes que utilitzarà l'usuari en iniciar sessió.
- **userPassword**: El hash de la contrasenya de l'usuari (en aquest cas, utilitzant l'algorisme SHA-512). Recordeu que aquesta és una versió encriptada de la contrasenya "1234" generada prèviament amb l'algorisme SHA-512. En la pràctica, caldria utilitzar un hash de la contrasenya de l'usuari que estigui segur.

Una pràctica comuna es la cració d'un usuari **OSProxy**. Aquest usuari té funcions específiques per a la resolució d'UIDs i GIDs. Aquesta separació de privilegis és una pràctica de seguretat que redueix l'abast de les possibles vulnerabilitats. Això millora la seguretat de la base de dades LDAP restringint l'accés només al que és necessari.

```bash
cat << EOL >> users.ldif
dn: cn=osproxy,ou=system,$BASE
objectClass: organizationalRole
objectClass: simpleSecurityObject
cn: osproxy
userPassword:{SSHA512}CBVaUdQC9mVvAi+0O92J3hA+aPdiWUqf4lVr6bGRAUsFJX5aFOEb+1pSsY8PQwW1UKuuCGO2+160HotnfjXIaRKlryVekLnu
description: OS proxy for resolving UIDs/GIDs

EOL

groups=("programadors" "dissenyadors")
gids=("5000" "5001")
users=("jordi" "manel")
sn=("mateo" "lopez")
uids=("4000" "4001")
programadors=("jordi")
dissenyadors=("manel")

for (( j=0; j<${#groups[@]}; j++ ))
do
cat << EOL >> users.ldif
dn: cn=${groups[$j]},ou=groups,$BASE
objectClass: posixGroup
cn: ${groups[$j]}
gidNumber: ${gids[$j]}

EOL
done

for (( j=0; j<${#users[@]}; j++ ))
do
cat << EOL >> users.ldif
dn: uid=${users[$j]},ou=users,$BASE
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
cn: ${users[$j]}
sn: ${sn[$j]}
uidNumber: ${uids[$j]}
gidNumber: ${uids[$j]}
homeDirectory: /home/${users[$j]}
loginShell: /bin/sh

EOL
done
```

Un cop creat el fitxer, carreguem la configuració a la base de dades:

```bash
ldapadd -Y EXTERNAL -H ldapi:/// -f users.ldif
```

### Configuració de certificats TLS

Els certificats TLS són una part important de la configuració de seguretat d'un servidor LDAP. Aquests certificats s'utilitzen per xifrar les comunicacions entre el client i el servidor, protegint les dades de ser interceptades per tercers.

Per configurar els certificats TLS en el servidor LDAP, necessitaràs generar un parell de claus privades i certificats públics, i configurar el servidor per utilitzar-los.

En primer lloc, genera un parell de claus privades i certificats públics amb la comanda `openssl`. A continuació, crea un fitxer `ldapcert.ldif` a `/etc/openldap/` amb el següent contingut:

```bash
HOSTNAME="amsa.udl.cat"
commonname=$HOSTNAME
country=ES
state=Spain
locality=Igualada
organization=UdL
organizationalunit=IT
email=admin@udl.cat

echo "Generating key request for $commonname"
openssl req -days 500 -newkey rsa:4096 \
    -keyout "$PATH_PKI/ldapkey.pem" -nodes \
    -sha256 -x509 -out "$PATH_PKI/ldapcert.pem" \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
```

En segon lloc, atorga els permisos adequats als fitxers de claus privades i certificats públics:

```bash
chown ldap:ldap "$PATH_PKI/ldapkey.pem"
chmod 400 "$PATH_PKI/ldapkey.pem"
cat "$PATH_PKI/ldapcert.pem" > "$PATH_PKI/cacerts.pem"
```

En tercer lloc, crea un fitxer `add-tls.ldif` a `/etc/openldap/` amb el següent contingut:

```bash
cat << EOL >> add-tls.ldif
dn: cn=config
changetype: modify
add: olcTLSCACertificateFile
olcTLSCACertificateFile: "$PATH_PKI/cacerts.pem"
-
add: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: "$PATH_PKI/ldapkey.pem"
-
add: olcTLSCertificateFile
olcTLSCertificateFile: "$PATH_PKI/ldapcert.pem"
EOL
```

Finalment, carrega la configuració a la base de dades:

```bash
ldapadd -Y EXTERNAL -H ldapi:/// -f add-tls.ldif
```

Un cop carregada la configuració, ja tindrem els certificats TLS configurats en el servidor LDAP.

### Testeig de la instal·lació

Per comprovar que la instal·lació ha estat correcta, pots utilitzar la comanda `ldapsearch` per buscar les entrades de la base de dades. Per exemple, pots buscar l'usuari que has creat amb la comanda següent:

```bash
ldapsearch -x -W -H ldapi:///  -D "cn=admin,dc=amsa,dc=udl,dc=cat"  -b "ou=users,dc=amsa,dc=udl,dc=cat"
```

Aquesta comanda utilitza l'usuari admin que has creat per connectar-se al servidor LDAP i buscar les entrades de la branca "ou=users,dc=amsa,dc=udl,dc=cat". Si tot ha anat bé, hauries de veure les dades dels usuaris que has creat.

> **Nota**: Us he creat un script que recull totes les comandes anteriors i les executa: [ldapserver.sh](src/ldapserver.sh)

### Comandes útils de LDAP

- **ldapsearch**: Per buscar entrades a la base de dades LDAP.
- **ldapadd**: Per afegir noves entrades a la base de dades LDAP.
- **ldapmodify**: Per modificar les entrades de la base de dades LDAP.
- **ldapdelete**: Per eliminar les entrades de la base de dades LDAP.
- **ldappasswd**: Per canviar la contrasenya d'un usuari a la base de dades LDAP.

Per exemple:

- Per modificar la contrasenya d'un usuari:

    ```bash
    ldappasswd -H ldapi:/// -D "cn=admin,dc=amsa,dc=udl,dc=cat" -x -W -S "uid=jordi,ou=users,dc=amsa,dc=udl,dc=cat"
    ```

    > Nota: Heu d'introduir la contrasenya xifrant amb SHA-512 com hem vist anteriorment.

- Podem comprovar que la contrasenya s'ha modificat correctament amb la comanda `ldapsearch`.

    ```bash
    ldapsearch -x -W -H ldapi:///  -D "uid=jordi,ou=users,dc=amsa,dc=udl,dc=cat"  -b "ou=users,dc=amsa,dc=udl,dc=cat"
    ```

## Exercicis

- Configura la base de dades **middlearth** amb els usuaris i grups creats a l'exercici anterior.

  - Crea un fitxer anomenat *middleearth.ldif* que contingui la configuració necessària per a la base de dades.
  - Carrega aquesta configuració al servidor LDAP mitjançant eines com ldapadd o ldapmodify.

```bash
BASE="dc=amsa,dc=udl,dc=cat"
groups=("hobbits" "elfs" "nans" "mags")
gids=("6000" "7000" "8000" "9000")

for (( j=0; j<${#groups[@]}; j++ ));
do
cat << EOL >> middleearth.ldif
dn: cn=${groups[$j]},ou=groups,$BASE
objectClass: posixGroup
cn: ${groups[$j]}
gidNumber: ${gids[$j]}

EOL
done
```

   ```bash
groups=("hobbits" "elfs" "nans" "mags")
gids=("6000" "7000" "8000" "9000")
users=("frodo" "gollum" "samwise" "legolas" "gimli" "gandalf")
b2g=("hobbits","hobbits","hobbits","elfs","nans","mags")
sn=("baggins" "smeagol" "gamgee" "greenleaf" "sonofgloin" "thegrey")
uids=("6001" "6002" "6003" "7001" "8001" "9001")

for (( j=0; j<${#users[@]}; j++ ))
do
cat << EOL >> users.ldif
dn: uid=${users[$j]},ou=users,$BASE
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
cn: ${users[$j]}
sn: ${sn[$j]}
uidNumber: ${uids[$j]}
gidNumber: ${b2g[$j]}
homeDirectory: /home/${users[$j]}
loginShell: /bin/sh
EOL
done
```

- Configura una altra instància EC2 com a client LDAP.

  - Assegura't que aquesta màquina autentiqui els usuaris i grups de Linux mitjançant el servidor LDAP configurat prèviament.

    Per configurar els nostres clients podem utilitzar un script que ens faciliti la tasca. Aquest script ens permetrà configurar el client LDAP amb les dades del servidor LDAP.

    Únicament caldrà modificar les variables `LDAP_SERVER` i `BASE` amb les dades del servidor LDAP. En el nostre cas, LDAP_SERVER ha de coincidir amb el DNS públic de la instància del servidor LDAP i BASE amb el nom de la base de dades que hem creat en el nostre cas `dc=amsa,dc=udl,dc=cat`. A més, caldrà copiar el fitxer `cacert.crt` del servidor LDAP al client.

    Per fer-ho, copieu el contingut del fitxer `/etc/pki/tls/cacerts.pem` del servidor LDAP al client i deseu-lo com a `/etc/pki/tls/cacert.crt`.

    ```bash
    # Al servidor
    sudo cat /etc/pki/tls/cacerts.pem

    # Al client
    sudo vi "/etc/pki/tls/cacert.crt"
    ```

    ```bash

    echo "This script will configure the client to connect to the LDAP server"

    echo "... Did you copy the cacert.crt from the server to the client? (y/n)?"

    read -r response

    if [ "$response" != "y" ]; then
        echo "Exiting..."
        exit 1
    fi

    # Variables
    LDAP_SERVER="ec2-44-206-252-61.compute-1.amazonaws.com"
    BASE="dc=amsa,dc=udl,dc=cat"
    PATH_PKI="/etc/pki/tls"

    echo "... Setting the hostname to $LDAP_SERVER"
    echo "... Setting the base to $BASE"
    echo "... Setting the path to $PATH_PKI"

    echo "... Are you sure you want to continue? (y/n), are this values correct?"

    read -r response

    if [ "$response" != "y" ]; then
        echo "Exiting..."
        exit 1
    fi

    echo "... Install deps and tools"

    dnf install openldap-clients sssd sssd-tools oddjob-mkhomedir -y

    echo "... Configuring sssd"

    cat << EOL >> /etc/sssd/sssd.conf
    [sssd]
    services = nss, pam, sudo
    config_file_version = 2
    domains = default

    [sudo]

    [nss]

    [pam]
    offline_credentials_expiration = 60

    [domain/default]
    ldap_id_use_start_tls = True
    cache_credentials = True
    ldap_search_base = $BASE
    id_provider = ldap
    auth_provider = ldap
    chpass_provider = ldap
    access_provider = ldap
    sudo_provider = ldap
    ldap_uri = ldaps://$LDAP_SERVER
    ldap_default_bind_dn = cn=osproxy,ou=system,$BASE
    ldap_group_search_base = ou=groups,$BASE
    ldap_user_search_base = ou=users,$BASE
    ldap_default_authtok = 1234
    ldap_tls_reqcert = demand
    ldap_tls_cacert = $PATH_PKI/cacert.crt
    ldap_tls_cacertdir = $PATH_PKI
    ldap_search_timeout = 50
    ldap_network_timeout = 60
    ldap_access_order = filter
    ldap_access_filter = (objectClass=posixAccount)
    EOL

    echo "... Configuring ldap.conf"

    echo "BASE $BASE" >> /etc/openldap/ldap.conf
    echo "URI ldaps://$LDAP_SERVER" >> /etc/openldap/ldap.conf
    echo "TLS_CACERT      $PATH_PKI/cacert.crt" >> /etc/openldap/ldap.conf
    authselect select sssd --force

    # Oddjob is a helper service that creates home directories for users the first time they log in

    echo "... Configuring oddjob"
    systemctl enable --now oddjobd
    echo "session optional pam_oddjob_mkhomedir.so skel=/etc/skel/ umask=0022" >> /etc/pam.d/system-auth 
    systemctl restart oddjobd

    echo "... Setting permissions"

    chown -R root: /etc/sssd
    chmod 600 -R /etc/sssd

    echo "... Starting sssd"

    systemctl enable --now sssd

    echo "... Done"
    ```

    Aquest script configura el client LDAP per connectar-se al servidor LDAP. Per fer-ho, instal·la les eines necessàries, com ara `openldap-clients`, `sssd`, `sssd-tools` i `oddjob-mkhomedir`. A continuació, configura el fitxer `sssd.conf` amb les dades del servidor LDAP i el fitxer `ldap.conf` amb les dades de connexió al servidor LDAP. Finalment, configura el servei `oddjobd` per crear els directoris d'inici dels usuaris la primera vegada que inicien sessió. Podeu trobar el script a [ldapclient.sh](src/ldapclient.sh).

    Per testar la configuració del client crearem un directori **/home/jordi** i l'assignarem a un usuari i a un grup inicialitzat a LDAP.

    ```bash
    sudo mkdir /home/jordi
    sudo chown 4000:5000 /home/jordi
    ```

    > Nota: L'usuari jordi no és un usuari local, sinó un usuari definit a LDAP. Per tant, si LDAP no està configurat correctament, veurem el valors numèrics 4000 i 5000 en lloc del nom de l'usuari i el grup.

    En canvi, si tot està configurat correctament, veurem el nom de l'usuari i el grup corresponents a aquests valors numèrics definits a LDAP.

    ```bash
    sudo ls -l /home
    drwxr-xr-x.  2 jordi programadors   6 Sep 26 18:36 jordi
    ```

- Instal·la i configura un client web per gestionar LDAP. Pots utilitzar l'eina [LAM](https://ldap-account-manager.org/lamcms/).

  - Instal·la LDAP Account Manager (LAM) a la instància del servidor LDAP.
  - Configura l'eina perquè es connecti al servidor LDAP i permeti la gestió dels usuaris i grups de manera visual utilitzant una interfície web.

    Per instal·lar LAM, primer cal instal·lar les dependències necessàries:

    ```bash
    sudo dnf install -y httpd php php-ldap php-mbstring php-gd php-gmp php-zip
    sudo systemctl enable --now httpd
    ```

    A continuació, descarrega i descomprimeix el paquet de LAM:

    ```bash
    sudo wget https://github.com/LDAPAccountManager/lam/releases/download/9.0.RC1/ldap-account-manager-9.0.RC1-0.fedora.1.noarch.rpm
    sudo dnf install ldap-account-manager-9.0.RC1-0.fedora.1.noarch.rpm
    ```

    Finalment, navega a la pàgina web de LAM a `http://<IP_SERVER>/lam` i segueix les instruccions per configurar la connexió al servidor LDAP. En el meu cas, he configurat la connexió al servidor LDAP amb les dades següents: `http://ec2-34-207-89-93.compute-1.amazonaws.com/lam`.

    ![LAM](./figs/lam/lam-01.png)

    Per configurar l'usuari per accedir a LAM, utilitzarem l'usuari `osproxy` que hem creat anteriorment. Aquest usuari té permisos per gestionar la base de dades LDAP. Per fer-ho, anem a **LAM Configuration**.

    ![LAM](./figs/lam/lam-02.png)

    Editeu **General Settings** i us identifiqueu amb l'usuari per defecte, i la contrasenya `lam`. En aquest punt, modifiqueu la contrasenya per una més segura, per exemple, `@ms@22o4G3i`.

    ![LAM](./figs/lam/lam-03.png)

    Editeu **Server Profiles** dins de **LAM Configuration** i modifiqueu el perfil perquè s'identifiqui amb l'usuari `osproxy` i la contrasenya que heu definit anteriorment. La contrasenya per defecte és `lam`. Us recomano que la modifiqueu per una més segura com per exemple `@ms@22o4G3i-s3rv3rPr0f1l3`.

    - General Settings:
      - Server Address: `ldaps://ec2-44-206-252-61.compute-1.amazonaws.com:636` o bé si esteu utilitzant el vostre servidor LDAP, `ldap://localhost:389`.
      - List of Valid Users: `cn=osproxy,ou=system,dc=amsa,dc=udl,dc=cat`.
      - Tree suffix: `dc=amsa,dc=udl,dc=cat`.
    - Account Types:
      - Users: `ou=users,dc=amsa,dc=udl,dc=cat`.
      - Groups: `ou=groups,dc=amsa,dc=udl,dc=cat`.

    Si tot ha anat bé, hauríeu de poder accedir a LAM amb l'usuari `osproxy` i gestionar els usuaris i grups de la base de dades LDAP.

    ![LAM](./figs/lam/lam-04.png)