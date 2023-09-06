#!/bin/bash

echo Script $0
echo $#

if [[ $# -ne 1 ]]
then
    echo usage: $0 '<computername>'
    exit
fi

TRANSFER=/home/ubuntu/transfer/$1


if [[ -d $TRANSFER ]]
then
    echo $TRANSFER found
else
    echo $TRANSFER not found
    exit
fi

SQUASH=/mnt/squash/$1
VOLUMES=/mnt/volumes/$1

echo mkdir -p $SQUASH
sudo mkdir -p $SQUASH
for simage in $TRANSFER/*.squashfs; do
    device=$(basename $simage .img.squashfs)
    size=$(ls -lh $simage | awk '{print $5}')
    echo found $device $size
done

read -p "Continue (y/n)?" -n 1 -r
echo # new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo aborted
    exit
fi

for simage in $TRANSFER/*.squashfs; do
    device=$(basename $simage .img.squashfs)
    size=$(ls -lh $simage | awk '{print $5}')
    echo found $device $size

    read -p "Mount (y/n)?" -n 1 -r
    echo # new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
	echo mounting ....
	echo   mkdir -p $SQUASH/$device
	sudo mkdir -p $SQUASH/$device
	echo   mount $simage $SQUASH/$device
	sudo mount $simage $SQUASH/$device
	echo   mkdir -p $VOLUMES/$device
	sudo mkdir -p $VOLUMES/$device
	echo   mount $SQUASH/$device/$device.img $VOLUMES/$device
	sudo mount -o ro,gid=1000,uid=1000  $SQUASH/$device/$device.img $VOLUMES/$device
	echo  #
    fi
    
done

echo done
