# Helper scripts to pull images from the hard drives

## Image backup workflow

1. Boot from a memory stick
2. Connect external drive, change path to the external drive, subdirectory "images/"
3. Run `hzb_pc_info.sh` to generate basic information about the computer

```sh
-rw-r--r-- 1 root        root         3938 Aug  4 05:44 fdisk.txt
-rw-r--r-- 1 root        root          325 Aug  4 05:44 ip.link.show
-rw-r--r-- 1 root        root          194 Aug  4 05:44 lsblk.txt
-rw-r--r-- 1 root        root         2267 Aug  4 05:44 lsblk_all.txt
-rw-r--r-- 1 root        root        14463 Aug  4 05:44 lshw.txt
```

4. Run `hzb_mk_image.sh` without parameters to get list of the devices:
```
root@test> hzb_mk_image.sh
USAGE: ../hzb_mk_image.sh DEVICE_NAME_OR_MASK [DEVICE_NAME [DEVICE_NAME ...]]

Example: ../hzb_mk_image.sh /dev/sdd? # all partitions on /dev/sdd

Known devices are:
sda      8:0    0 931.5G  0 disk 
├─sda1   8:1    0   100M  0 part 
├─sda2   8:2    0  52.5G  0 part 
├─sda3   8:3    0   293G  0 part 
├─sda4   8:4    0     1K  0 part 
├─sda5   8:5    0  93.4G  0 part 
├─sda6   8:6    0   293G  0 part 
├─sda7   8:7    0   3.9G  0 part 
└─sda8   8:8    0 195.8G  0 part 
sdb      8:0    0    10T  0 disk 
├─sdb1   8:1    0   100M  0 part 
├─sdb2   8:2    0  52.5G  0 part 
...
```

5. Run `hzb_mk_image.sh` on selected partitions:
```
# Save all partitions of sda device
root@test> hzb_mk_image.sh /dev/sda? 
```

```
# Save only /dev/sda1 /dev/sda2 /dev/sda8
root@test> hzb_mk_image.sh /dev/sda1 /dev/sda2 /dev/sda8
```

