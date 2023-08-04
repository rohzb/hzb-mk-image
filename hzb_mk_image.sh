#!/bin/bash
#################################################################################
#
# Automatic image creation with squashfs
#
# version 1.5	- Using progress from 'dd' - helps to copy speed and progress
#					 better (Ruslan)
# version 1.4	- fixed error with multiple parameters (Ruslan)
# version 1.3	- show device names if run without parameters (Ruslan)
#		- updated help (Ruslan)
# Version 1.2 	- auto elevate privileges
# Version 1.1 	- ask for deletion of on old images (Ruslan)
#		- allow multiple input devices (Ruslan)
# Version 1.0 	- basic functionality (Ruslan) 
#
#################################################################################

#set -x

# show usage info if there run without parameters
if [ x"$1" == x"" ]; then
	echo USAGE: $0 DEVICE_NAME_OR_MASK [DEVICE_NAME [DEVICE_NAME ...]]
	echo ""
	echo "Example: $0 /dev/sdd? # all partitions on /dev/sdd"
	echo ""
	echo "Known devices are:"
	lsblk
	exit -1
fi

# Ensure that this script runs under sudp
if [[ $EUID -ne 0 ]];
then
    exec sudo /bin/bash "$0" "$@"
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
	if [ ! -f $SQUASH ]; then 
		mksquashfs /tmp/dummy $SQUASH -no-progress -p "$IMAGE  f 0444 root root dd if=$DEVICE bs=4M conv=sync,noerror status=progress"
	fi
done

