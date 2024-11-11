# Quota

- Quota allows you to specify limits on two aspects of disk storage: 

	- The number of disk blocks that may be allocated to a user or 

		a group of users.

	- The number of inodes a user or a group of users may possess.

- Debian: s'ha d'insta·lar el paquet quota:

	```bash
	# apt-get install quota
	```
## Creating a user (joan)


```bash
1. # useradd joan

2. # chown -R joan:joan /home/joan 

// set the /home/joan owner and group to joan

3. # passwd joan    // set the passwd

4. Edit /etc/passwd and /etc/shadow to see if all is correct.

5. # userdel joan // to erase user joan
```

## Creating a group (students)


```bash
1. # groupadd students

2. Edit /etc/group and modify the line:

students:x:504:joan,arqui

3. Edit /etc/gshadow and modify the line:

students:::joan,arqui

4. # groupdel students // to erase group students
```

## Activating the quota system


1. Compile the kernel with Quota support.

2. Activate the quota software. You have to reboot the system. 

3. The new kernel with quota support will be loaded and the startup script 
	Red Hat (/etc/rc.d/rc.sysinit) or Debian (/etc/init.d/quota) will execute:

	- "**quotacheck**": updates quota databases. 

	- "**quotaon"**: turns on quota accounting. quotaoff: turns it off.


- The filesystems with quota support are specified in /etc/fstab with option:

	- "**usrquota**". For setting user quotas.

	- "**grpquota**". For setting group quotas.


## File /etc/init.d/quota

Aquest fitxer conté algo paregut a: 

```bash
if [ -x /usr/sbin/quotacheck ]   # true (0) if file exists and is executable

then

            echo "Checking quotas. This may take some time. “ 

            /usr/sbin/quotacheck 

            echo " Done." 

fi 

if [ -x /usr/sbin/quotaon ] 

then 

            echo "Turning on quota." 

            /usr/sbin/quotaon -a

fi
```

## Soft and hard limits; grace period

-  "**soft limit**" indicates the maximum amount of disk usage a quota user has on a partition. Combined with grace period, when passed (the soft limit), the user is informed with a quota violation warning.

-  "**hard limit**" It specifies the absolute limit on the disk usage.

-  "**grace period**" if the soft limit is passed, the grace period will be the elapsed time before deny to write. Viewing/modifying grace periods:

	```bash
	# edquota -t
	
	Grace period before enforcing soft limits for users: 
	Time units may be: days, hours, minutes, or seconds
	|------------|--------------------|--------------------|
	| Filesystem | Block grace period | Inode grace period |
	|------------|--------------------|--------------------|
	| /dev/hdb1  | 7days              | 7days              |
	| /dev/hdb2  | 7days              | 7days              |
	|------------|--------------------|--------------------|
	```
	

## Assigning quota for user joan

```bash
# cd /home; touch aquota.user   % Creates the file /home/aquota.user

# quotacheck -u % Edit quotas for joan [in a particular filesystem]

# edquota -u joan [-f /home/joan] 
 Disk quotas for user joan (uid 502): 
 |------------|--------|------|------|--------|------|------|
 | Filesystem | Blocks | Soft | Hard | Inodes | Soft | Hard |
 |------------|--------|------|------|--------|------|------|
 | /dev/hdb1  | 0      | 0    | 0    | 0      | 0    | 0    |
 | /dev/hdb2  | 76     | 8000 | 96000| 15     | 0    | 0    |
 |------------|--------|------|------|--------|------|------|
```
 
- Note: "**# edquota**" takes me into the vi editor (change editor with the $EDITOR environment variable). "blocks" are in KB. There are 76 blocks and and 15 inodes assigned to user joan in hdb2.\vspace{-0.3cm}


## Assigning quota for user arqui


- One of both:

	```bash
	1. # edquota -u arqui  
	Disk quotas for user arqui (uid 503): 
	|------------|--------|------|------|--------|------|------|
	| Filesystem | Blocks | Soft | Hard | Inodes | Soft | Hard |
	|------------|--------|------|------|--------|------|------|
	| /dev/hdb1  | 72     | 7000 | 8000 | 14     | 0    | 0    |
	| /dev/hdb2  | 0      | 0    | 0    | 0      | 0    | 0    |
	|------------|--------|------|------|--------|------|------|
	```

	```bash
	2. # edquota -p joan arqui [francesc ....]  
	Assigning joan's quota to the remaining users
	```	

	
## Assigning quota for group students

```bash

# cd /home

# touch aquota.group

# quotacheck -g

# edquota -g students %  Edit quotas for students [in a particular filesystem]
 Disk quotas for group students (gid 504):
|------------|--------|------|-------|--------|------|------|
| Filesystem | Blocks | Soft | Hard  | Inodes | Soft | Hard |
|------------|--------|------|-------|--------|------|------|
| /dev/hdb1  | 72     | 9500 | 10000 | 14     | 0    | 0    |
| /dev/hdb2  | 76     | 9500 | 10000 | 15     | 0    | 0    |
|------------|--------|------|-------|--------|------|------|
```
Note: takes me again into the vi editor

## Miscellaneous Quota Commands


```bash
# quotaoff   // turn quota accounting off

# quotacheck -u  // update quota accounting for users in all filessytems

# quotacheck -g   // update quota accounting for users groups in all filesystems

# quotaon -a   // turn quota accounting on
```


```bash
# quota -u joan % See joan's quota information
Disk quotas for user joan (uid 502):
|------------|--------|-------|-------|-------|-------|-------|-------|-------|
| Filesystem | Blocks | Quota | Limit | Grace | Files | Quota | Limit | Grace |
|------------|--------|-------|-------|-------|-------|-------|-------|-------|
| /dev/hdb2  | 76     | 8000  | 9600  |       | 15    | 0     | 0     |       |
|------------|--------|-------|-------|-------|-------|-------|-------|-------|
```
Note: inodes and files are equivalent terms

```bash
# rep quota % printing quota information

# repquota -u %  producing a summarized user quota information

*** Report for user quotas on device /dev/hdb1 

Block grace time: 7days; Inode grace time: 7days 
                    Block limits                         File limits
| User  | Used | Soft | Hard | Grace | Used | Soft | Hard | Grace |
|-------|------|------|------|-------|------|------|------|-------|
| root  | -    | -    | 16   | 0     | 0    | 2    | 0    | 0     |
| arqui | -    | -    | 72   | 7000  | 8000 | 14   | 0    | 0     |
|-------|------|------|------|-------|------|------|------|-------|


*** Report for user quotas on device /dev/hdb2 

Block grace time: 7days; Inode grace time: 7days 
                    Block limits                         File limits
| User     | Used | Soft | Hard  | Grace | Used | Soft | Hard  | Grace |
|----------|------|------|-------|-------|------|------|-------|-------|
| root     | -    | -    | 16    | 0     | 0    | 2    | 0     | 0     |
| students | -    | -    | 76    | 9500  | 10000| 15   | 0     | 0     |
|-------|------|------|------|-------|------|------|------|-------|
```


# repquota -g %  producing a summarized group quota information.

```bash

*** Report for group quotas on device /dev/hdb1 

Block grace time: 7days; Inode grace time: 7days 


*** Report for group quotas on device /dev/hdb2 

Block grace time: 7days; Inode grace time: 7days 
```