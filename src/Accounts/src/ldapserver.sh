#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Variables
HOSTNAME="ec2-34-207-89-93.compute-1.amazonaws.com"
VER="2.6.3"
BASE="dc=amsa,dc=udl,dc=cat"
PATH_PKI="/etc/pki/tls"
DC="amsa"

echo "... Hostname: $HOSTNAME"
echo "... Version: $VER"
echo "... Base: $BASE"
echo "... Path: $PATH_PKI"
echo "... DC: $DC"

echo "... Are you sure you want to continue? (y/n), are this values correct?"
read -r response

if [ "$response" != "y" ]; then
    echo "Exiting..."
    exit 1
fi

# Preparing the hostname
echo "... Setting the hostname to $HOSTNAME"
hostnamectl set-hostname $HOSTNAME --static

# Install Required Dependencies and Build Tools
echo "... Install deps and tools"
dnf install cyrus-sasl-devel make libtool autoconf libtool-ltdl-devel\
 openssl-devel libdb-devel tar gcc perl perl-devel wget vim screen -y

echo "... Adding user and group (ldap:ldap)"
groupadd -g 55 ldap
useradd -r -M -d /var/lib/openldap -u 55 -g 55 -s /usr/sbin/nologin ldap

echo "... Downloading openldap"
cd /tmp
wget ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-$VER.tgz
tar xzf openldap-$VER.tgz
cd openldap-$VER

echo "... Configure sources (open-ldap)"
./configure --prefix=/usr --sysconfdir=/etc --disable-static \
--enable-debug --with-tls=openssl --with-cyrus-sasl --enable-dynamic \
--enable-crypt --enable-spasswd --enable-slapd --enable-modules \
--enable-rlookups  --disable-sql  \
--enable-ppolicy --enable-syslog

make depend
make
cd contrib/slapd-modules/passwd/sha2
make
cd ../../../..

echo "... Installing (open-ldap)"
# Instal·lació OpenLfap
make install

# Instal·lant sha2
cd contrib/slapd-modules/passwd/sha2
make install

# Els fitxers de configuració d'OpenLDAP es guarden a /etc/openldap.
ls -la /etc/openldap/

# Les llibreries s'han instal·lat a /usr/libexec/openldap.
ls -la /usr/libexec/openldap


# Creació dels directories per les dades i la base de dades
mkdir /var/lib/openldap /etc/openldap/slapd.d

# Atorguem els permipermisosssos
chown -R ldap:ldap /var/lib/openldap
chown root:ldap /etc/openldap/slapd.conf
chmod 640 /etc/openldap/slapd.conf


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

cd /etc/openldap/
slapadd -n 0 -F /etc/openldap/slapd.d -l /etc/openldap/slapd.ldif
chown -R ldap:ldap /etc/openldap/slapd.d

systemctl daemon-reload
systemctl enable --now slapd

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

ldapadd -Y EXTERNAL -H ldapi:/// -f rootdn.ldif

echo "...Generating basedn file"
cat << EOL >> basedn.ldif
dn: $BASE
objectClass: dcObject
objectClass: organization
objectClass: top
o: ASV
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

ldapadd -Y EXTERNAL -H ldapi:/// -f basedn.ldif

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

ldapadd -Y EXTERNAL -H ldapi:/// -f users.ldif

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

chown ldap:ldap "$PATH_PKI/ldapkey.pem"
chmod 400 "$PATH_PKI/ldapkey.pem"
cat "$PATH_PKI/ldapcert.pem" > "$PATH_PKI/cacerts.pem"

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


ldapadd -Y EXTERNAL -H ldapi:/// -f add-tls.ldif
