#!/bin/bash
#################################################################################
#
# Automatic image creation with squashfs
#
# Version 1.1  - ask for deletion of on old images
# Version 1.0 - basic functionality (Ruslan) 
#
#################################################################################

#set -x

if [ x"$@" == x"" ]; then
	echo USAGE: $0 DEVICE_NAME_OR_MASK [DEVICE_NAME [DEVICE_NAME ...]]
	exit -1
fi

DEVICE_MASK="$@"

for DEVICE in $DEVICE_MASK; do
	BASENAME=$(basename "$DEVICE")
	IMAGE=${BASENAME}.img
	SQUASH=${IMAGE}.squashfs

	echo Processing device $DEVICE. Will create $SQUASH image with $IMAGE data inside

	mkdir -p /tmp/dummy

	if [ -f $SQUASH ]; then 
		while true; do
			read -p "Image $SQUASH already exists! Do you want to delte it? [y/n] " yn
			case $yn in 
				[yY]) rm $SQUASH
					break;;
				[nN]) break;;
				* ) echo invalid response;;
			esac
		done
	fi
	echo mksquashfs /tmp/dummy $SQUASH -p "$IMAGE  f 0444 root root dd if=$DEVICE bs=4M conv=sync,noerror"
done

