#!/bin/bash
#################################################################################
#
# Automatic image creation with squashfs
#
# Version 1.1 	- removed "-l" from lsblk, elevate privileges only once (Ruslan)
# Version 1.0 	- basic functionality (Ruslan) 
#
#################################################################################

# Ensure that this script runs under sudo
if [[ $EUID -ne 0 ]];
then
    exec sudo /bin/bash "$0" "$@"
fi

# generate computer info
fdisk -l >fdisk.txt
lsblk >lsblk.txt
lsblk --output-all >lsblk_all.txt
lshw >lshw.txt
ip link show >ip.link.show

