#!/bin/bash

echo Script $0

if [[ $# -ne 1 ]]
then
    echo usage: $0 '<computername>'
    exit
fi

SQUASH=/mnt/squash/$1
VOLUMES=/mnt/volumes/$1
TRANSFER=/home/ubuntu/transfer/$1

if [[ -d $VOLUMES ]]; then
    echo found volumes dirs $VOLUMES
    VOLUMES_DEV=$(mount | grep $VOLUMES | awk '{ print $3}')
    for vdisk in $VOLUMES_DEV; do
	echo " " umount $vdisk
	sudo umount $vdisk
	echo " " rmdir $vdisk
	sudo rmdir $vdisk
    done
    echo " " rmdir $VOLUMES
    sudo rmdir $VOLUMES
else
    echo volumes dirs not found $VOLUMES
fi

if [[ -d $SQUASH ]]; then
    echo found squash dirs $SQUASH
    SQUASH_DEV=$(mount | grep $SQUASH | awk '{ print $3}')
    for sdisk in $SQUASH_DEV; do
	echo " " umount $sdisk
	sudo umount $sdisk
	echo " " rmdir $sdisk
	sudo rmdir $sdisk
    done
    echo " " rmdir $SQUASH
    sudo rmdir $SQUASH
else
    echo squash dirs not found $SQUASH
fi

if [[ -d $TRANSFER ]]; then
    echo "The local image uses space of $(du -sh ${TRANSFER}) ."
    read -p "Should the local image files also deleted (y/n)?" -n 1 -r
    if [[ $REPLY =~ ^[YyZz]$ ]]; then
        rm -rf $TRANSFER
    fi
fi

echo done
