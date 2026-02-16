# Do it before running!!!!
# Al servidor fer: cat /etc/pki/tls/cacerts.pem -> copieu 
# Al client -> vim "/etc/pki/tls/cacert.crt"
# pegar el contingut copiat del servidor i guardar

echo "This script will configure the client to connect to the LDAP server"

echo "... Did you copy the cacert.crt from the server to the client? (y/n)?"

read -r response

if [ "$response" != "y" ]; then
    echo "Exiting..."
    exit 1
fi

# Variables
LDAP_SERVER="ec2-34-207-89-93.compute-1.amazonaws.com"
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
