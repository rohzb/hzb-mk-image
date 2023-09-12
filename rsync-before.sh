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

BASEDIR=${SRC%/*}
BASENAME=${SRC##*/}

if [ -z "$BASENAME" ]; then
    BASENAME="."
fi

${DIR}/find-files-before.sh "${SRC}" | rsync -av ${OPTS} --exclude-from="${DIR}/exclude.txt" --files-from=- --from0 "${BASEDIR}" "${DEST}"
