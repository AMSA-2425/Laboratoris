# Gestió de comptes (Lord of the system)

![](./figs/lord-of-the-ring-trilogy.png)

Tres anillos para los Reyes Elfos bajo el cielo.

Siete para los Señores Enanos en casas de piedra.

Nueve para los Hombres Mortales condenados a morir.

Uno para el Señor Oscuro, sobre el trono oscuro.

Un Anillo para gobernarlos a todos. Un anillo para encontrarlos,

un Anillo para atraerlos a todos y atarlos en las tinieblas

en la Tierra de Mordor donde se extienden las Sombras

## Objectius

* Aprendre a gestionar comptes en servidors UNIX/Linux.
* Familiaritzar-se amb els mecanismes de protecció i control d'usuaris.

## Requisits

En aquesta pràctica, es demana que es creïn comptes d'usuari en un sistema Linux. Aquests comptes hauran de ser creats amb diferents permisos i restriccions, i s'hauran de configurar els grups i els permisos de fitxers i directoris per a cada usuari. Per tant, reviseu les comandes i els conceptes següents abans de començar:

* **useradd**: Aquesta comanda s'utilitza per crear nous usuaris en un sistema Linux. Cada usuari té un identificador únic (**UID**) i pot ser assignat a un o més grups. Aquesta comanda també pot crear els directoris inicials (home directories) pels usuaris.
* **groupadd**: Aquesta comanda s'utilitza per crear nous grups en un sistema Linux. Els grups són una manera de gestionar col·leccions d'usuaris, permetent una administració eficaç de permisos i accés als recursos del sistema. Els grups ajuden a organitzar i controlar els usuaris amb un mateix conjunt de permisos.
* **usermod**: Aquesta comanda s'utilitza per modificar els atributs d'un usuari en un sistema Linux. Aquests atributs poden incloure el nom de l'usuari, el directori home, el grup principal, el shell, el UID, el GID, etc.
* **passwd**: Aquesta comanda s'utilitza per canviar la contrasenya d'un usuari en un sistema Linux. Aquesta comanda permet als usuaris canviar la seva pròpia contrasenya o als administradors canviar la contrasenya d'altres usuaris.
* **chown**: Aquesta comanda s'utilitza per canviar el propietari i el grup d'un fitxer o directori en un sistema Linux. Aquesta comanda permet als usuaris canviar el propietari i el grup d'un fitxer o directori, sempre que tinguin els permisos necessaris.
* **chmod**: Aquesta comanda s'utilitza per canviar els permisos d'un fitxer o directori en un sistema Linux. Aquesta comanda permet als usuaris canviar els permisos d'un fitxer o directori, especificant els permisos per a propietaris, grups i altres usuaris.
* **setfacl/getfacl**: Aquestes comandes s'utilitzen per establir i obtenir llistes de control d'accés (ACL) en un sistema Linux. Les ACL són una manera de controlar l'accés als fitxers i directoris, permetent als usuaris especificar permisos més detallats que els permisos tradicionals de propietari, grup i altres usuaris.

## Preparant el servidor

Instancieu un servidor **RedHat** a la plataforma **AWS**. Aquest servidor serà el vostre **Middlearth**.

1. Actualitzar totes les llibreries amb ```sudo dnf update -y```.
2. Instal·lar un editor de text (vim o nano) amb ```sudo dnf install vim -y```.
3. Instal·lar la shell tcsh amb ```sudo dnf install tcsh -y```.
4. Actualitzar el nom de l'amfitrió amb: ```sudo hostnamectl set-hostname middlearth```.

## Mostrant informació de benvinguda

El fitxer **/etc/motd** és l'arxiu on es guarda un missatge de benvinguda; normalment és un arxiu de text senzill que es mostra als usuaris quan inicien sessió. Pot contenir informació com la benvinguda al sistema, informació d'actualitat, polítiques de l'empresa, enllaços a recursos importants o qualsevol altra cosa que es consideri útil per als usuaris en el moment d'iniciar sessió.

Copieu el text següent al fitxer **/etc/motd**:

```txt
#                Bienvenido a la tierra media!                  #
#                            *  *  *                            #
#                         *  *  *  *  *                         #
#                      *  *  *  *  *  *  *                      #
#                      *  *  *  *  *  *  *                      #
#                      *  *  *  *  *  *  *                      #
#                         *  *  *  *  *                         #
#                            *  *  *                            #
# El hogar está atrás, el mundo por delante, y ha               #
# y muchos caminos que recorrer a través de la                  #
# sombras hasta el borde de la noche, hasta que                 #
# las estrellas estén encendidas                                #
#################################################################
```

```sh
 sudo vim /etc/motd 
# Afegiu la informació a l'arxiu.
 exit
```

Tornem a iniciar sessió **SSH**. Per veure el nostre banner, després de fer *login*.

## Mostrant informació: Connexions remotes

L'arxiu **/etc/issue.net** és similar al missatge del dia (**/etc/motd**), però aquest s'utilitza per mostrar un missatge als usuaris abans que aquests s'autentiquin en un servidor mitjançant protocols com *SSH*. Aquest missatge normalment conté informació bàsica o una benvinguda als usuaris quan intenten connectar-se al servidor.

Per activar-ho:

1. Copieu el contingut del fitxer */etc/issue.net* a */etc/issue.net.default*. D'aquesta manera sempre mantindrem una còpia del fitxer original sense editar.
2. Copieu el següent text al fitxer */etc/issue.net*:

```txt
#################################################################
#                   _    _           _   _                      #
#                  / \  | | ___ _ __| |_| |                     #
#                 / _ \ | |/ _ \ '__| __| |                     #
#                / ___ \| |  __/ |  | |_|_|                     #
#               /_/   \_\_|\___|_|   \__(_)                     #
#                                                               #
#               You are entering into Mordor!                   #
#   Username has been noted and has been sent to the server     #
#                       administrator!                          #
#################################################################
```

Finalment, tornem a iniciar sessió **SSH**. Per veure el nostre banner.

```sh
 sudo cp /etc/issue.net /etc/issue.net.default
 sudo vim /etc/issue.net
# Copieu el text
# Guardar i sortir
```

Per podeu veure el banner, s'ha d'editar la configuració del servei SSH:

```sh
sudo vim /etc/ssh/sshd_config
# Descomentar 
Banner /etc/issue.net
# Guardar i sortir
sudo systemctl restart sshd
exit
```

## Creació de grups

La comanda **groupadd** s'utilitza per crear nous grups en un sistema Linux. Els grups són una manera de gestionar col·leccions d'usuaris, permetent una administració eficaç de permisos i accés als recursos del sistema. Els grups ajuden a organitzar i controlar els usuaris amb un mateix conjunt de permisos.

```sh
groupadd [opcions] nom_del_grup
```

### Crea 4 grups amb els següents GIDs

|**nom**|**GID**|
|---|---|
|hobbits| 6000|
|elfs| 7000|
|nans| 8000|
|mags| 9000|

```sh
sudo groupadd -g 6000 hobbits 
sudo groupadd -g 7000 elfs 
sudo groupadd -g 8000 nans 
sudo groupadd -g 9000 mags
```

o bé:

```sh
declare -a groups=("hobbits" "elfs" "nans" "mags")
declare -a gids=(6000 7000 8000 9000)
for i in "${!groups[@]}"; do
    sudo groupadd -g ${gids[$i]} ${groups[$i]}
done
```

## Creant els usuaris

La comanda *useradd* s'utilitza per crear nous usuaris en un sistema Linux. Cada usuari té un identificador únic (**UID**) i pot ser assignat a un o més grups. Aquesta comanda també pot crear els directoris inicials (home directories) pels usuaris.

### Crea els següents comptes

|**usuari**  |**UID**|**GID**|**nom**    |
|--------|---|---|-------|
|frodo   |6001|6000|Frodo  |
|gollum  |6002|6000|Smeagol|
|samwise |6003|6000|Samwise|
|legolas |7001|7000|Legolas|
|gimli   |8001|8000|Gimli  |
|gandalf |9001|9000|Gandalf|

```sh
sudo useradd frodo -g 6000 -u 6001 -c "Frodo, portador de l'anell" -m -d /home/frodo 
sudo useradd gollum -g 6000 -u 6002 -c "Smeagol, el cercador de l'anell" -m -d /home/gollum 
sudo  useradd samwise -g 6000 -u 6003 -c "Samwise, l'amic fidel" -m -d /home/samwise 
sudo  useradd legolas -g 7000 -u 7001 -c "Legolas, el mestre de l'arc" -m -d /home/legolas 
sudo  useradd gimli -g 8000 -u 8001 -c "Gimli, el valent guerrer" -m -d /home/gimli
sudo  useradd gandalf -g 9000 -u 9001 -c "Gandalf, el mag" -m -d /home/gandalf
```

o bé:

```sh
declare -a users=("frodo" "gollum" "samwise" "legolas" "gimli" "gandalf")
declare -a uids=(6001 6002 6003 7001 8001 9001)
declare -a gids=(6000 6000 6000 7000 8000 9000)
declare -a comments=("Frodo, portador de l'anell" "Smeagol, el cercador de l'anell" "Samwise, l'amic fidel" "Legolas, el mestre de l'arc" "Gimli, el valent guerrer" "Gandalf, el mag")
for i in "${!users[@]}"; do
    sudo useradd ${users[$i]} -g ${gids[$i]} -u ${uids[$i]} -c "${comments[$i]}" -m -d /home/${users[$i]}
done
```

## Protegint els comptes

S'ha de requerir contrasenyes robustes per als comptes d'usuari. De manera predeterminada, tots els comptes d'usuari tenen assignada la contrasenya *Tolkien2LOR*. Un cop l'usuari es connecti per primera vegada, haurà de canviar la contrasenya. A més, s'ha de configurar el sistema perquè bloquegi els comptes d'usuari després de 3 intents fallits.

1. Assigna la contrasenya *Tolkien2LOR* a tots els usuaris.

    ```sh
    declare -a users=("frodo" "gollum" "samwise" "legolas" "gimli" "gandalf")
    for user in "${users[@]}"; do
        echo "Tolkien2LOR" | sudo passwd --stdin $user
    done
    ```

2. Configura el sistema per bloquejar els comptes d'usuari després de 3 intents fallits durant 120 segons. D'aquesta manera, prevenim els atacs de força bruta i protegim els comptes d'usuari. Per fer-ho, podem utilitzar **faillock** en versions més recents de **RHEL**. En versions anteriors, es podia utilitzar **pam_tally2**.

    * Activa el mòdul **faillock**:

    ```sh
    sudo authselect select sssd with-faillock
    ```

    * Configura el mòdul **pam_faillock** per bloquejar els comptes d'usuari després de 3 intents fallits. El compte es desbloquejarà automàticament després de 120 segons.

    ```sh
    sudo vi /etc/security/faillock.conf
    
    # Descomenta i modifica les següents línies del fitxer
    deny=3
    unlock_time=120
    audit
    ```

    * Per testar el bloqueig del compte, intenta iniciar sessió amb una contrasenya incorrecta 3 vegades. Després de 3 intents fallits, el compte s'hauria de bloquejar durant 120 segons.

    * Per desbloquejar manualment un compte:

    ```sh
    sudo faillock --user frodo --reset
    ```

3. Configura polítiques de contrasenyes més fortes

   * Edita el fitxer /etc/security/pwquality.conf per establir requisits estrictes per a les contrasenyes:

        ```sh
        sudo vi /etc/security/pwquality.conf
        minlen=12  # Longitud mínima de la contrasenya
        dcredit=-1 # Requereix un dígit
        ucredit=-1 # Requereix una lletra en majúscula
        ocredit=-1 # Requereix un caràcter especial
        lcredit=-1 # Requereix una lletra en minúscula
        enforcing=1 # Força l'ús de les polítiques de contrasenya
        ```

    * Per verificar-ho, intenta canviar la contrasenya d'un usuari i comprova que compleix/no compleix els requisits establerts.


4. Requereix el canvi de contrasenya en el primer inici de sessió.

   * Per assegurar que els usuaris canviïn la contrasenya predeterminada després de connectar-se per primera vegada, activa aquesta opció:


    ```sh
    declare -a users=("frodo" "gollum" "samwise" "legolas" "gimli" "gandalf")
    for user in "${users[@]}"; do
        sudo chage -d 0 $user
    done
    ```

## Accés a la comarca (SSH)

Configura el servidor SSH per permetre l'accés als usuaris Frodo, Samwise, Legolas i Gimli utilitzant contrasenya. L'usuari Gandalf ha de poder accedir al sistema utilitzant una clau SSH. No s'ha de permetre l'accés a l'usuari Gollum o a l'usuari root.

1. Configura el servidor SSH per permetre l'accés als usuaris Frodo, Samwise, Legolas i Gimli utilitzant contrasenya.

    ```sh
    sudo vi /etc/ssh/sshd_config
    AllowUsers frodo samwise legolas gimli
    PasswordAuthentication yes

    AllowUsers gandalf ec2-user
    PubkeyAuthentication yes
    ```

    > Nota: La instancia EC2 de RedHat utilitza el fitxer de configuració **/etc/ssh/sshd_config/50-cloud-init.conf** per configurar el servei SSH. Aquest fitxer s'inclou en el fitxer de configuració principal **/etc/ssh/sshd_config**.

2. Afegeix la clau pública de l'usuari Gandalf al fitxer **~/.ssh/authorized_keys**.

    ```sh
    sudo mkdir /home/gandalf/.ssh
    sudo chmod 600 /home/gandalf/.ssh
    sudo vi /home/gandalf/.ssh/authorized_keys
    # Afegeix la clau pública de l'usuari Gandalf
    sudo chown -R gandalf:mags /home/gandalf/.ssh
    ```

3. Bloqueja l'accés a l'usuari Gollum.

    ```sh
    sudo usermod -s /sbin/nologin gollum
    ```

4. Reinicia el servei SSH per aplicar els canvis.

    ```sh
    sudo systemctl restart sshd
    ```

## Gandalf, el mag

L'usuari **gandalf** vol tenir permisos de **root**. Per fer-ho, l'afegirem al grup **wheel**.

```sh
sudo usermod -aG wheel gandalf
```

o bé:

```sh
sudo gpasswd -a gandalf wheel
```

Per defecte, en les instancies EC2 d'Amazon Linux, el grup **wheel** no està habilitat. L'usuari **ec2-user** té permisos utilitzant l'eina **sudo**.

Per utilitzar la comanda **sudo** amb l'usuari **gandalf**:

```sh
sudo visudo
```

Afegiu la següent línia al fitxer:

```sh
gandalf ALL=(ALL) ALL
```

Si volem que l'usuari **gandalf** pugui executar comandes com a **root** sense necessitat de contrasenya, podem afegir la següent línia al fitxer **/etc/sudoers**:

```sh
gandalf ALL=(ALL) NOPASSWD: ALL
```

En les instancies EC2 d'Amazon Linux, l'usuari **ec2-user** ja té permisos de **sudo**, aquesta configuració es troba dins del fitxer **/etc/sudoers.d/90-cloud-init-users**. Podeu aprofitar i afegir l'usuari **gandalf** a aquest fitxer.
Podeu comprovar que l'usuari **gandalf** té permisos de **root** executant la comanda **sudo**.

```sh
sudo cat /etc/shadow
```

## Actualitzant Usuaris

* L'usuari **gollum** vol tenir el seu *home* amb el nom **smeagol**.

```sh
sudo usermod -d /home/smeagol -m gollum
```

* L'usuari **legolas** vol tenir per defecte la *shell tcsh*.

```sh
sudo usermod -s /bin/tcsh legolas
```

* L'usuari **gimli** no vol tenir *contrasenya*.

```sh
sudo passwd -d gimli
```

## Notificació de la comarca

Un cop s'han creat els usuaris entrarem al sistema com a **frodo** i enviarem un *mail* a la resta amb el següent missatge: **Benvinguts a la companyia, anem direcció mordor**.

```sh
sudo dnf -y install postfix
sudo dnf -y install s-nail
```

Postfix és un programari de servidor de correu electrònic que té com a objectiu principal gestionar l'enviament, recepció i l'encaminament de correus electrònics en un entorn de servidor. És conegut per la seva eficiència, seguretat i flexibilitat, i és àmpliament utilitzat en servidors de correu electrònic en tot el món.

### Configuració del postfix

Editeu el fitxer */etc/postfix/main.cf*:

* **myhostname** = mail.middlearth.udl.cat
* **mydomain** = udl.cat
* **myorigin** = \$mydomain
* **inet_interfaces** = all
* **inet_protocols** = ipv4
* **mydestination** = \$myhostname, localhost.$mydomain, localhost, \$mydomain
* **mynetworks** = 127.0.0.0/8
* **home_mailbox** = Maildir/

Afegiu al final del fitxer */etc/postfix/main.cf*:

```conf
# Amaga el tipus o la versió del programari SMTP
smtpd_banner = $myhostname ESMTP

# Afegeix el següent al final
# Desactiva la comanda SMTP VRFY
disable_vrfy_command = yes

# Requereix la comanda HELO als amfitrions emissors
smtpd_helo_required = yes

# Límit de mida d'un correu electrònic
# Exemple a continuació significa límit de 10M bytes
message_size_limit = 10240000

# Configuracions SMTP-Auth
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes
smtpd_sasl_security_options = noanonymous
smtpd_sasl_local_domain = $myhostname
smtpd_recipient_restrictions = permit_mynetworks, permit_auth_destination, permit_sasl_authenticated, reject
```

### Configurant el dimoni

* Arrancant el dimoni
  
```sh
sudo systemctl enable --now postfix
```

### Prova

```sh
su - ganfalf
echo "Benvinguts a la companyia, anem direcció mordor." | mail -s "Notificació de la comarca" frodo@localhost
su - frodo
mail
```

## El poder de l'anell

* Crearem un directori **/anell**.

```sh
sudo mkdir /anell
```

* Crearem un grup portadors.

```sh
sudo groupadd portadors
```

* Assignarem a frodo com a propietari del directori **/anell**.

```sh
sudo chown frodo:portadors /anell
```

* Modificarem els permisos del directori: Els fitxers d’aquest directori únicament podran ser **executats/editats** per l’usuari **Frodo**, la resta d’usuaris no ha de tenir cap permís ni de lectura, a excepció del grup d'usuari del grup **portadors** que *han de poder llegir el directori*.

```sh
sudo chmod a-rwx /anell
sudo chmod g+r /anell
sudo chmod u+rwx /anell
```

* En **Frodo** ha de poder executar tots els fitxers del director **/anell/bin** sense haver d'afegir tota la ruta, únicament indicant el nom de l'executable.

```sh
sudo echo "export PATH=$PATH:/anell/bin" >> $HOME/.bashrc 
sudo source $HOME/.bashrc 
```

## Final del viatge

* Gimli es confon amb tots els missatges que apareixen a la pantalla quan inicia sessió. Configureu el seu compte perquè no es mostri cap missatge a la pantalla quan comenci la sessió.

```sh
su gimli
touch ~/.hushlogin
```

* No s’ha de permetre que en Gimli executi programes des del seu propi directori **/home**. Per fer-ho heu d'utilitzar (**setfacl**):

```sh
sudo setfacl -m u:gimli:--- /home/gimli
```

* L’usuari Samwise s’ha perdut i ha acabat a Narnia, elimineu-lo de l’univers.

```sh
sudo userdel -r samwise
```