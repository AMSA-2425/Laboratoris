## LVM COMMANDS 

- Initializing disks or disk partitions

	- For entire disks: 
		```bash
		# pvcreate /dev/hdb
		```

	- For partitions: set the partition type to 0x8e using fdisk. Next: 
		```bash
		# pvcreate /dev/hdb1
		pvcreate – physical volume "/dev/hdb1" successfully created
		```

- Creating a VG: 

	```bash
	# vgcreate my_VG /dev/hdb1 [/dev/hdc1] ... 

		vgcreate – INFO: using default physical extent size 4 MB (default) 

		vgcreate – INFO: maximum logical volume size is 255.99 Gigabyte

		vgcreate – doing automatic backup of volume group "my_VG" 

		vgcreate – volume group "my_VG" successfully created and activated
	```
	
	```bash
	# more /etc/lvmtab
		my_VG
	```


- Activating a VG: 

	```bash
	# vgchange -ay my_VG 
	```

	Note: in the startup script 

- Removing a VG:

	1. Deactivate the VG: `# vgchange -an my_VG`

	2. Remove the VG: `# vgremove my_VG` 

- Adding PVs to a VG:

	```bash
	# pvcreate /dev/sdb2

	# vgextend my_VG /dev/sdb2
	```

- Removing PVs from a VG: 

	```bash
	# vgreduce my_VG /dev/sdb2 
	```

- Creating an LV in my_VG: 

	```bash
	# lvcreate options -nmy_LV
	```

	Main options:

	-C y/n Linear. Default is no Linear (Striped)

	-i PV_Number number of PVs to scatter the LV. 

	-I S_Size Strip size (in KBytes). The strip is the transactions unit.

	-l LEs_Number number of LEs (LE size = PE size) for the new LV. 

	-L LV_Size[kKmMgGtT] size for the new LV. K (kilobytes), M (megabytes), G (gigabytes) or T (terabytes). Default unit is megabytes. 

	-n LV_Name 

	-p r/w permission


- Creating a 1500MB linear LV named my_LV in my_VG:

	```bash
	# lvcreate -Cy -L1500 -nmy_LV my_VG
	```

- Creating a LV of size 100 LEs (or PEs), with 2 PVs and strip size of 4 KB:

	```bash
	# lvcreate -i2 -I4 -l100 -nmy_LV my_VG 

	# vgdisplay my_VG

	— Volume group — 

	VG Name my_VG 

	VG Access read/write 
	
	VG Status available/resizable 

	VG # 0 

	MAX LV 256
	
	VG Size 1.95 GB
	
	PE Size 4 MB 
	
	Total PE 498 
	
	Alloc PE / Size 100 / 400 MB 
	
	Free PE / Size 398 / 1.55 GB 
	```

- Creating an LV that uses the entire VG, use vgdisplay to find the "Total PE" size, then use that when running lvcreate:

	```bash
	# vgdisplay my_VG | grep "Total PE" 

		Total PE 10230 

	# lvcreate -l10230 my_VG -nmy_LV 
	```

- Creating an ext4 file system on the LV

	```bash
	# mke2fs /dev/my_VG/my_LV
	```

- Mounting and Testing the File System

	```bash
	# mount -t auto /dev/my_VG/my_LV /mnt/LV1 
	
	# df
	```
	
- Obtaining LV information

	```bash
	# lvdisplay /dev/my_VG/my_LV (strip size 4KB)
	```

- Removing a LV

	```bash
	# umount /dev/my_VG/my_LV && lvremove /dev/my_VG/my_LV
	```

## Extending (+4MBs) a LV (/dev/my_VG/my_LV) mounted on /mnt/LV1: 

```bash
# lvextend -L+4M /dev/my_VG/my_LV

# umount /dev/my_VG/my_LV

# e2fsck -f /dev/my_VG/my_LV

# resize2fs /dev/my_VG/my_LV

# mount /dev/my_VG/my_LV /mnt/LV1
```


## Reducing (-4MBs) a LV (/dev/my_VG/my_LV) mounted on /mnt/LV1

```bash
# lvreduce -L-4M /dev/my_VG/my_LV

# umount /mnt/LV1

# e2fsck -f /dev/my_VG/my_LV

# resize2fs /dev/my_VG/my_LV

# mount /dev/my_VG/my_LV /mnt/LV1
```