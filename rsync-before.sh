#!/bin/bash

function usage {
	echo "usage: $(basename ${0}) <src> <dst>"
	exit
}

DIR=$(dirname ${0})

if [[ ! -z S1 ]];
 then 
	SRC=${1}; 
else
	usage
fi
if [[ ! -z S2 ]];
then 
	DEST=${2}
else 
	usage
fi

rsync -avz --exclude-from=${DIR}/exclude.txt --exclude-from=<(${DIR}/find-files-after.sh ${SRC}) ${SRC} ${DEST}
