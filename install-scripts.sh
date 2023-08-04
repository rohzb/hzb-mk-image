#!/bin/bash
#################################################################################
#
# Helper script to install scripts to /usr/local/bin
#
# Version 1.0 	- basic functionality (Ruslan) 
#
#################################################################################


# Ensure that this script runs under sudo
if [[ $EUID -ne 0 ]];
then
    exec sudo /bin/bash "$0" "$@"
fi


# Do the installation
install -m 0755 hzb_* /usr/local/bin

