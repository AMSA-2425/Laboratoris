# Serveis programats

Un altra funcionalitat interessant de systemd és la possibilitat de programar la execució de serveis amb `systemd.timer`. Aquesta funcionalitat permet programar la execució de serveis en un moment concret o de forma periòdica. Això pot ser útil per realitzar tasques de manteniment automàticament, com ara còpies de seguretat, actualitzacions de sistema, etc.

Anem a veure com podem programar l'actualització del sistema amb un servei `apt-update` i un temporitzador `apt-update.timer` cada dia a les 00:00.

1. **Crea un fitxer de servei `apt-update.service`**: Crea un fitxer de servei `apt-update.service` a `/etc/systemd/system/apt-update.service` amb el següent contingut:

    ```ini
    [Unit]
    Description=Update the package list

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/apt update
    ```

    Aquest fitxer de servei executa la comanda `apt update` per actualitzar la llista de paquets del sistema.

2. **Crea un fitxer de temporitzador `apt-update.timer`**: Crea un fitxer de temporitzador `apt-update.timer` a `/etc/systemd/system/apt-update.timer` amb el següent contingut:

    ```ini
    [Unit]
    Description=Run apt-update daily at 00:00

    [Timer]
    OnCalendar=daily

    [Install]
    WantedBy=timers.target
    ```

    Aquest fitxer de temporitzador programa l'execució del servei `apt-update.service` cada dia a les 00:00.

3. **Inicia el temporitzador**: Inicia el temporitzador `apt-update.timer` amb la comanda `systemctl start apt-update.timer`.

    ```bash
    systemctl start apt-update.timer
    ```

4. **Habilita el temporitzador**: Habilita el temporitzador `apt-update.timer` perquè s'executi a l'arrencada amb la comanda `systemctl enable apt-update.timer`.

    ```bash
    systemctl enable apt-update.timer
    ```

    > 💡 **Nota**:
    >
    > Podeu utilitzar ```systemctl enable --now unitat``` per iniciar i habilitar una unitat al mateix temps.

5. **Comprova l'estat del temporitzador**: Comprova l'estat del temporitzador `apt-update.timer` amb la comanda `systemctl status apt-update.timer`.

Una vegada configurat el temporitzador, el sistema executarà el servei `apt-update.service` cada dia a les 00:00 per actualitzar la llista de paquets del sistema.

![systemctl status apt-update.timer](../figures/systemd/systemctl-status-apt-update-timer.png)
