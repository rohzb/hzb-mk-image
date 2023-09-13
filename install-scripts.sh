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

# Ensure that current dir is correct
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

# Do the installation
install -m 0755 d*.sh f*.sh h*.sh r*.sh s*.sh /usr/local/bin
