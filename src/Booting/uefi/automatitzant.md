# Automatitzant l'Arrancada

> **👁️ Observació:**
> 
> Aquest procediment és una mica tedios i ens pot resultar poc eficient si hem d'arrencar el sistema operatiu Debian sovint.

Per automatitzar l'arrancada del sistema operatiu Debian, podeu utilitzar la comanda `boot` de la consola UEFI. Aquesta comanda us permetrà carregar un fitxer d'arrancada directament sense haver de navegar per la partició ESP.

```bash
boot fs2:\EFI\debian\grubaa64.efi
```

Tot i que aquesta comanda pot ser útil, encara requereix accedir manualment a la consola UEFI i introduir la comanda. Per tant, ara veurem com crear una entrada d'arrancada personalitzada a la taula d'arrancada de la UEFI semblant a la ja existent per a l'arrancada d'AlmaLinux anomenda `AlmaLinux`.
