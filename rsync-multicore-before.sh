#!/bin/bash

function usage {
	echo "usage: $(basename ${0}) <src> <dst> [extra-opts]"
	exit
}

DIR=$(dirname ${0})

if [[ ! -z ${1} ]];
 then 
	SRC="${1}"
	shift
else
	usage
fi
if [[ ! -z $1 ]];
then 
	DEST="${1}"
	shift
else 
	usage
fi

OPTS="${@}"

ls ${SRC} | xargs -n1 -P4 -I% rsync -Pa "${OPTS}" --exclude-from="${DIR}/exclude.txt" --exclude-from=<(${DIR}/find-files-between.sh "%") % "${DEST}"
