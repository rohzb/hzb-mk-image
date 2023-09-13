#!/bin/bash

echo Script $0
echo $#

if [ $# -ne 1 -o -z "$1" ]
then
    echo usage: $0 '<computername>'
    exit 1
fi

TRANSFER=/home/ubuntu/transfer/$1

if [ -d ${TRANSFER} ]
then
    echo ${TRANSFER} found
else
    echo ${TRANSFER} not found
    IMAGESRC=$(find /mnt -maxdepth 2 -iwholename "/mnt/images*/$1" -type d|tail -n 1)
    if [ -d ${IMAGESRC} ]; then
        echo "found image directory on NAS: $(du -sh ${IMAGESRC})"
        read -p "Should the image copied from NAS (y/n)?" -n 1 -r
        if [[ $REPLY =~ ^[YyZz]$ ]]; then
	    echo ""
            mkdir -p ${TRANSFER} > /dev/null 2>&1
            cp -iv --target-directory ${TRANSFER} ${IMAGESRC}/* || exit $?
        else
            echo "aborted"
            exit 1
        fi
    fi
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
if [[ ! $REPLY =~ ^[YyZz]$ ]]
then
    echo aborted
    exit 1
fi

EXITCODE=0
for simage in $TRANSFER/*.squashfs; do
    device=$(basename $simage .img.squashfs)
    size=$(ls -lh $simage | awk '{print $5}')
    echo found $device $size

    read -p "Mount (y/n)?" -n 1 -r
    echo # new line
    if [[ $REPLY =~ ^[YyZz]$ ]]
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
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
            sudo umount $SQUASH/$device
	    sudo rmdir $VOLUMES/$device $SQUASH/$device
	    echo "failed to mount $simage"
	fi
        test $RESULT -gt $EXITCODE && EXITCODE=$RESULT
	echo  #
    fi
done

echo done
exit $EXITCODE
