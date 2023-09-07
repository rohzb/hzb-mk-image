# Helper scripts to pull images from the hard drives and to make images read-only accessible

for previous version: see below

## create an image of a PC

- for Dell PC while powering on press (repeatly or hold) F12
- go to BIOS setup and disable "secure boot" and set "SATA operation"
  from "RAIDon" to "AHCI" (others leave alone), restart
- for Dell PC while powering on press (repeatly or hold) F12
- boot a PC with a live Linux, e.g. LinuxMint
- plug in an external transfer disk and mount it (automatically)
- open a terminal, go to transfer disk
  ```cd /media/ubuntu/DATA-TRANSFER…``` and
  execute ```bash scripts/squash-image.sh```
- enter computers name
- select disk(s) to take images (exclude transfer disk and booted Linux stick)
- after that "continue" and wait for finish
- look for error messages!
- unmount transfer disk

## restore files from previous images

### installation structure

- boot a PC with a live Linux, e.g. LinuxMint

- connect this PC to internet and install ntfs-3g, mc
  ```root@test> apt update && apt install ntfs-3g mc```

- disconnect PC from internet

- build this directory structure, /mnt as root (e.g. "sudo -i")
``
  /
  ├─ home
  │  └─ ubuntu
  │     ├─ scripts
  │     └─ transfer
  └─ mnt
     ├─ images
     ├─ images2
     ├─ squash
     └─ volumes
```

- connect PC to the NAS system and read-only mount image folder to
  ```/mnt/images```, ```/mnt/images2```, …
  ```root@test> mount -t nfs <ip-addr>:/volume1/images /mnt/images -o ro```

- copy these scripts as ubuntu user to ```/home/ubuntu/scripts```

- open a terminal and start midnight commander
  ```mc```

- with help of mc: copy from image directory (see above) the needed computer
  images to ```/home/ubuntu/transfer```

- open a second terminal and mount disk image
  ```bash scripts/dev-mount.sh <computername>```

- an user comes with a transfer medium, mount it

- open a third terminal and start rsync copy script
  ```bash scripts/rsync-before.sh /mnt/squash /media/ubuntu/<transfer-disk>```

- in the second terminal unmount disk image
  ```bash scripts/dev-unmount.sh <computername>```

### usage

- open terminal

# Ruslan previous README:

## Installation

Use helper script to run the installation: `bash -e install-scripts.sh`

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
