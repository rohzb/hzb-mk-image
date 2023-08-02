#!/bin/bash
#################################################################################
#
# Automatic image creation with squashfs
#
# Version 1.0 - basic functionality, 
#
#################################################################################

#set -x

if [ x"$1" == x"" ]; then
	echo USAGE: $0 DEVICE_NAME_OR_MASK
	exit -1
fi

DEVICE_MASK="$1"

for DEVICE in $DEVICE_MASK; do
	BASENAME=$(basename "$DEVICE")
	IMAGE=${BASENAME}.img
	SQUASH=${IMAGE}.squashfs

	echo Processing device $DEVICE. Will create $SQUASH image with $IMAGE data inside

	mkdir /tmp/dummy

	rm $SQUASH

	mksquashfs /tmp/dummy $SQUASH -p "$IMAGE  f 0444 root root dd if=$DEVICE bs=4M conv=sync,noerror"
	rmdir /tmp/dummy
done

