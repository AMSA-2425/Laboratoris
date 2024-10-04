# Configuració de la Xarxa

El servei de xarxa de systemd en Linux es diu systemd-networkd (`/usr/lib/systemd/system/systemd-networkd.service`). Aquest és un servei de gestió de xarxa que s'encarrega de configurar i gestionar dispositius de xarxa, enrutament i altres aspectes relacionats amb la connectivitat en sistemes basats en systemd.

Exemple de fitxer `systemd-networkd.service` d'una Debian 12.2:

```sh
[Unit]
Description=Network Configuration
Documentation=man:systemd-networkd.service(8)
Documentation=man:org.freedesktop.network1(5)
ConditionCapability=CAP_NET_ADMIN
DefaultDependencies=no
# systemd-udevd.service can be dropped once tuntap is moved to netlink
After=systemd-networkd.socket systemd-udevd.service network-pre.target systemd-sysusers.service systemd-sysctl.service
Before=network.target multi-user.target shutdown.target initrd-switch-root.target
Conflicts=shutdown.target initrd-switch-root.target
Wants=systemd-networkd.socket network.target

[Service]
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_BROADCAST CAP_NET_RAW
BusName=org.freedesktop.network1
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_BROADCAST CAP_NET_RAW
DeviceAllow=char-* rw
ExecStart=!!/lib/systemd/systemd-networkd
ExecReload=networkctl reload
FileDescriptorStoreMax=512
LockPersonality=yes
MemoryDenyWriteExecute=yes
NoNewPrivileges=yes
ProtectProc=invisible
ProtectClock=yes
ProtectControlGroups=yes
ProtectHome=yes
ProtectKernelLogs=yes
ProtectKernelModules=yes
ProtectSystem=strict
Restart=on-failure
RestartKillSignal=SIGUSR2
RestartSec=0
RestrictAddressFamilies=AF_UNIX AF_NETLINK AF_INET AF_INET6 AF_PACKET
RestrictNamespaces=yes
RestrictRealtime=yes
RestrictSUIDSGID=yes
RuntimeDirectory=systemd/netif
RuntimeDirectoryPreserve=yes
SystemCallArchitectures=native
SystemCallErrorNumber=EPERM
SystemCallFilter=@system-service
Type=notify
User=systemd-network
WatchdogSec=3min

[Install]
WantedBy=multi-user.target
```


## Resum del paassos en la configuració de la xarxa

Bàsicament, els passos que realitza el servei de xarxa, són els següents:

1. Aquest servei executa `ifup -a`, la qual inicialitza tots (opció  `-a`) els dispositius de xarxa.

2. Per configurar els dispositius de xarxa, la comanda ifup té en compte el fitxer de configuració /etc/network/interfaces

3. El fitxer /etc/network/interfaces informa de com s'ha de configurar la xarxa. Per fer-ho s'utilitza les paraules clau següents:

	(a) auto: configuració automàtica (en l'arranc del sistema, quan es fa “ifup -a”)

	(b) dhcp (static): configuració d'adreces de forma dinàmica (dhcp) o de forma stàtica (static)



## CONFIGURACIÓ DE LA XARXA - Adreces Dinàmiques - DHCP (Dynamic Host Configuration Protocol) -

Contingut del fitxer `/etc/network/interfaces`:

```sh
# The loopback interface 

auto lo

iface lo inet loopback

# The network interface

auto eth0

iface eth0 inet dhcp

```

## CONFIGURACIÓ DE LA XARXA - Adreces Fixes -



Contingut del fitxer `/etc/network/interfaces`:


```sh
# The loopback network interface 

auto lo 

iface lo inet loopback

# The primary network interface 

auto eth0 

iface eth0 inet static 

  address 192.168.1.90

  gateway 192.168.1.1 

  netmask 255.255.255.0 

  network 192.168.1.0 

  broadcast 192.168.1.255
```

## Ordres Útils

Ordres útils

```sh
$ hostname 
francesc-VirtualBox 
```


```sh
$ domainname
udl.cat
```


```sh
$ /sbin/ifconfig

eth0 Link encap:Ethernet HWaddr 08:00:27:9f:b6:af

     inet addr:10.0.2.15 Bcast:10.0.2.255 Mask:255.255.255.0

     inet6 addr: fe80::a00:27ff:fe9f:b6af/64 Scope:Link

     UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1

     RX packets:41057 errors:0 dropped:0 overruns:0 frame:0

     TX packets:24924 errors:0 dropped:0 overruns:0 carrier:0 

     collisions:0 txqueuelen:1000 

     RX bytes:30677670 (30.6 MB) TX bytes:1829477 (1.8 MB)
```


