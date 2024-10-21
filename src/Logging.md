# Sistema Logging - rsyslog

Sistema que recull totes les incidències que passa en el sistema.

El sistema de logging (`rsyslog`), està activat per defecte en Debian 12, i el seu fitxer de configuració principal és `/etc/rsyslog.conf`. 

## Passos per configurar-lo:

1. Instal·lar rsyslog (si no està instal·lat):

	```bash
	# apt update
	# apt install rsyslog
	```

2. Editar el fitxer de configuració principal: Obre el fitxer `/etc/rsyslog.conf`, i canviar les regles.

3. Format regla:	**selector  action**

	`selector` format : 	**facility.priority**

		• facility keywords: auth, authpriv, cron, daemon, ftp, kern, lpr, mail, mark, 
			news, security (same as auth), syslog, user, uucp, local0 → local7

		• priority keywords (in ascending order): debug, info, notice, warning, warn 
			(same as warning), err, error (same as err), crit, alert, emerg, 
			panic (same as emerg). warn, error and panic are deprecated.

4. Special keywords 

	`*` : 		all facilities or priorities. 

	`none` : 	no priority of the given facility. Used to exclude

	`,` : 		multiple facilities (comma separated facilities)

	`;` : 		multiple selectors (colon separated selectors)

	`=` : 		specify only this single priority and not any higher priority

	`!` : 		ignore all that priorities and any higher priority

	`-` : 		omit syncing the file after every logging

	`|` : 		pipe. Useful for debugging (to apply program filters)
	

5. Exemple. `Regles` del fitxer `/etc/rsyslog.conf`

	\# Standard logfiles. Log by facility 

	```bash
	auth,authpriv.* 	/var/log/auth.log 

	*.*;auth,authpriv.none 	-/var/log/syslog 

	cron.* 			/var/log/cron.log 

	daemon.* 		-/var/log/daemon.log 

	kern.* 			-/var/log/kern.log 

	mail.* 			-/var/log/mail.log 

	user.* 			-/var/log/user.log 

	uucp.* 			/var/log/uucp.log 
	```


	\# Logging for the mail system. 


	```bash
	mail.info  -/var/log/mail.info  %info and higer priorities to /var/log/mail.info

	mail.warn  -/var/log/mail.warn 

	mail.err   /var/log/mail.err 
	```

	\# Logging for news system 

	```bash
	news.crit 	/var/log/news/news.crit 

	news.err 	/var/log/news/news.err 

	news.notice 	-/var/log/news/news.notice 
	```


	\# Other 

	```bash
	*.=debug;auth,authpriv.none;news.none;mail.none -/var/log/debug 

	*.=info;*.=notice;*.=warn;auth,authpriv.none;cron,daemon.none;\ 

	mail,news.none -/var/log/messages 
	```


	\# Emergencies are sent to everybody logged in. 

	```bash
	*.emerg * 
	```


	\# Per enviar-ho a una tty: 

	```bash
	daemon,mail.*;news.=crit;news.=err;news.=notice;\ 

	*.=debug;*.=info;*.=notice;*.=warn /dev/tty6
	```


	\# Per enviar a la cònsola, primer executar: `$ xconsole -file /dev/console [...] `
	

	\# Després en fitxer `/etc/rsyslog.conf`

	```bash
	daemon.*;mail.*;news.crit;news.err;news.notice;*.=debug;*.=info;\ 

	*.=notice;*.=warn |/dev/xconsole
	```

7. Altres exemples

- The following lines would log all messages of the facility mail except those with the priority info to the /usr/adm/mail file. And all messages from news.info (including) to news.crit (excluding) would be logged to the /usr/adm/news file.

	```bash
	mail.*;mail.!=info /usr/adm/mail 

	news.info;news.!crit /usr/adm/news

	The following are equivalents:

		mail.none or mail.!* or mail.!debug 


8. System calls

	Opening a connection to the system logger for a program. 

	```bash
	#include <syslog.h>
	void openlog(const char *ident, int option, int facility); 
	```

	
	The string pointed to by `ident` is prepended to every message. 
	
	The `option` argument to openlog() is an OR of any of these:

		LOG_CONS Write directly to system console if there is an error while 
			sending to system logger.

		LOG_PERROR Print to stderr as well

		LOG_PID Include PID with each message

		- - - - - - - - - - - - - - - - - - - - - - - - - - - - altres menys importants
		
	
	`facility` is  used to specify what type of program is logging the message: 

		LOG_AUTH (DEPRECATED Use LOG_AUTHPRIV instead) 

		LOG_AUTHPRIV security/authorization messages (private) 

		LOG_CRON clock daemon (cron and at) 

		LOG_DAEMON system daemons without separate facility value 

		LOG_FTP ftp daemon 

		LOG_KERN kernel messages 

		LOG_LOCAL0 through LOG_LOCAL7 reserved for local use 

		LOG_LPR line printer subsystem 

		LOG_MAIL mail subsystem 

		LOG_NEWS USENET news subsystem 

		LOG_USER (default) generic user-level messages 
		

	Generating a log message

	```bash
	void syslog(int priority, const char *format, ...); 
	```

	`priority`  of the message:

		LOG_EMERG system is unusable

		LOG_ALERT action must be taken immediately

		LOG_CRIT critical conditions

		LOG_ERR error conditions

		LOG_WARNING warning conditions

		LOG_NOTICE normal, but significant condition

		LOG_INFO informational message

		LOG_DEBUG debug-level message


	Closing the connection to the system logger for a program. 

	```bash
	void closelog(void);
	```

## Comandes importants

- Per veure els missatges del nucli

```bash
$ dmesg
```

- Per veure tots missatges del sistema

```bash
$ journalctl
```