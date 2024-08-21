# Creant i Gestionant serveis

En aquesta secció, crearem un servei systemd per realitzar una còpia de seguretat del sistema a l'arrencada. Aquest servei s'executarà automàticament quan el sistema s'arrenqui i realitzarà una còpia de seguretat del sistema a una ubicació específica. Aquest servei pot ser interessant en situacions on l'ús pot comportar la pèrdua de dades o la corrupció del sistema.

1. **Crea un script de còpia de seguretat**: Crea un script de còpia de seguretat a `/usr/local/bin/backup`.sh amb el següent contingut:

    ```bash
    #!/bin/bash

    # Còpia de seguretat del sistema
    tar -czf /backup/system_backup_$(date +%Y%m%d).tar.gz /etc /var
    ```

    Aquest script realitzarà una còpia de seguretat dels directoris `/etc` i `/var` a la ubicació `/backup` amb el nom `system_backup_YYYYMMDD.tar.gz`, on `YYYYMMDD` és la data actual.

2. **Crea un fitxer de servei systemd**: Crea un fitxer de servei systemd a `/etc/systemd/system/backup.service` amb el següent contingut:

    ```ini
    [Unit]
    Description=System Backup Service
    After=network.target

    [Service]
    Type=oneshot
    ExecStart=/usr/local/bin/backup.sh

    [Install]
    WantedBy=multi-user.target
    ```

    Aquest fitxer de servei defineix un servei `backup` que s'executarà un cop s'hagi carregat el sistema de fitxers. El servei executarà l'script de còpia de seguretat `backup.sh` al directori `/usr/local/bin`. El servei s'instal·larà a la unitat `multi-user.target`, de manera que s'executarà quan el sistema hagi carregat tots els serveis necessaris.

3. **Inicia el servei**: Inicia el servei `backup` amb la comanda `systemctl start backup`.

    ```bash
    systemctl start backup
    ```

4. **Comprova l'estat del servei**: Comprova l'estat del servei `backup` amb la comanda `systemctl status backup`.

    ```bash
    systemctl status backup
    ```

5. **Habilita el servei**: Habilita el servei `backup` perquè s'executi a l'arrencada amb la comanda `systemctl enable backup`.

    ```bash
    systemctl enable backup
    ```

6. **Reinicia el sistema**: Reinicia el sistema per aplicar els canvis.

    ```bash
    reboot
    ```

7. **Comprova si el servei s'ha executat**: Després de reiniciar el sistema, comprova si el servei `backup` s'ha executat correctament.

    ```bash
    ls /backup
    ```

Ara el sistema arranca de forma més lenta ja que s'executa el servei de còpia de seguretat. Podeu utilitzat les comandes `systemd-analyze` i `systemd-analyze blame` per comparar els temps d'arrencada abans i després de la creació del servei.

En el meu cas, el temps d'arrencada ha augmentat lleugerament després de crear el servei de còpia de seguretat:

|Inicial | Després de crear el servei | Diferència |
|--------|----------------------------|------------|
| 2.973s | 10.380s                    | +7.407s    |

> Observació:
> 
> Noteu que l'augment es produeix en l'espai d'usuari, ja que el servei de còpia de seguretat s'executa després de carregar les funcions del kernel. Això és normal, ja que el servei de còpia de seguretat pot trigar una estona a completar-se, especialment si els directoris `/etc` i `/var` són grans.
