# Cron


- Idea: daemon which executes commands periodically. F.e.: quotacheck

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
| #  | Description           | Range                |
|----|-----------------------|----------------------|
| 1  | Minute                | 0-59                 |
| 2  | Hour                  | 0-23                 |
| 3  | Day of Month          | 1-31                 |
| 4  | Month                 | 1-12                 |
| 5  | Day of Week           | 0-6 (0 for Sun)      |
| 6  | User                  |                      |
| 7  | Reserved Word  run-parts or command       |  |
| 8  | Scripting Directory  or empty        |  |



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