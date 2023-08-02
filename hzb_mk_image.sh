#!/bin/bash
#################################################################################
#
# Automatic image creation with squashfs
#
# Version 1.1 	- ask for deletion of on old images (Ruslan)
#		- allow multiple input devices (Ruslan)
# Version 1.0 	- basic functionality (Ruslan) 
#
#################################################################################

#set -x

# show usage info if there run without parameters
if [ x"$@" == x"" ]; then
	echo USAGE: $0 DEVICE_NAME_OR_MASK [DEVICE_NAME [DEVICE_NAME ...]]
	exit -1
fi

DEVICE_MASK="$@"

# Iterate over all parameters/mask
for DEVICE in $DEVICE_MASK; do

	BASENAME=$(basename "$DEVICE")	# device base name
	IMAGE=${BASENAME}.img		# partition image name
	SQUASH=${IMAGE}.squashfs	# squashfs image name

	echo Processing device $DEVICE. Will create $SQUASH image with $IMAGE data inside

	mkdir -p /tmp/dummy # ensure that the dummy directory exists

	# check if an old image already there, ask to delete if yes
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

	# create squashfs image
	mksquashfs /tmp/dummy $SQUASH -p "$IMAGE  f 0444 root root dd if=$DEVICE bs=4M conv=sync,noerror"
done

