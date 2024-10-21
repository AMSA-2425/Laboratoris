# Cron


- Idea: daemon which executes commands periodically. P.e.: quotacheck

- File `/etc/crontab` (contains 8 fields):

```bash
# setting environment variables

SHELL = /bin/bash 

PATH = /sbin:/bin:/usr/sbin:/usr/bin 

MAILTO = root 

HOME = / 

# run-parts 

0 * * * * root run-parts /etc/cron.hourly 

0 1 * * * root run-parts /etc/cron.daily 

0 1 * * 0 root run-parts /etc/cron.weekly 

0 2 1 * * root run-parts /etc/cron.monthly 

cron.* are directories containing scripts to be executed hourly, daily, weekly or monthly

Note: run-parts execute all the scripts in a directory
```



##  Example (running quotacheck weekly)

-  One of both:

	1. add the following script in the directory /etc/cron.weekly: 

		```bash
		/sbin/quotacheck -g && exit 0 
		```

	2. add the following line in /etc/crontab: 

		```bash
		0 1 * * 0 root /sbin/quotacheck -g
		```