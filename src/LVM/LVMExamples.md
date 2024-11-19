## EXAMPLES

## Setting up LVM on three SCSI disks (/dev/sda, /dev/sdb, and /dev/sdc) with striping   

- Preparing the disk partitions

	```bash
	# pvcreate /dev/sda 

	# pvcreate /dev/sdb 

	# pvcreate /dev/sdc 
	```

- Setup a VG

	1. Create a VG

		```bash
		# vgcreate my_VG /dev/sda /dev/sdb /dev/sdc 
		```

	2. Run `# vgdisplay` to verify volume group

- Creating the LV (1GB) with 3 PVs and strip size of 4 KB on the VG:

	```bash
	# lvcreate -i3 -I4 -L1G -nmy_LV my_VG
	```

- Creating an ext4 file system on the LV

	```bash
	# mke4fs /dev/my_VG/my_LV
	```

- Mount and Test the File System

	```bash
	# mount /dev/my_VG/my_LV /mnt 
	
	# df 
	```



## Snapshot

1. Creating a snapshot of an entire LV: 

	```bash
	# lvdisplay my_LV | grep "LV Size" 

		LV Size	50.00 GiB 

	# lvcreate -L50G -s -nmy_LV_backup  /dev/my_VG/my_LV
	```

2. Mount the snapshot volume: 

	```bash 
	# mkdir /mnt/my_LV_backup 

	# mount /dev/my_VG/my_LV_backup /mnt/my_LV_backup 
	```

3. Remove the snapshot:

	```bash
	# umount /mnt/my_LV_backup

	# lvremove /dev/my_VG/my_LV_backup 
	```



## Removing an Old Disk (`/dev/sdb`)

1. Distributing Old Extents to Existing Disks in VG

	```bash
	# pvmove /dev/sdb 
	```

2. Remove the unused disk

	```bash
	# vgreduce my_VG /dev/sdb 
	```

3. The drive can now be removed when the machine is powered down


## Replace an old disc (`/dev/sdb`) with a new one (`/dev/sdf`)

1. Preparing the new disk

	```bash
	# pvcreate /dev/sdf 
	```

2. Add it to the VG my_VG

	```bash
	# vgextend my_VG /dev/sdf 
	```

3. Moving the data

	```bash
	# pvmove /dev/sdb /dev/sdf 
	```

4. Removing the unused disk

	```bash
	# vgreduce my_VG /dev/sdb 
	```

5. The drive can now be removed when the machine is powered down

