#!/bin/bash

sudo fdisk -l >fdisk.txt
sudo lsblk -l >lsblk.txt
sudo lsblk --output-all >lsblk_all.txt
sudo lshw >lshw.txt
sudo ip link show >ip.link.show

