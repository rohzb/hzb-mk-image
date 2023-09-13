#! /bin/bash

IFS="
"
if [[ $1 == "" ]]; then
	DIR="."
else
	DIR=${1}
fi

#BASEDIR=$(dirname $DIR)
#BASENAME=$(basename $DIR)

#echo basedir = $BASEDIR
#echo basename = $BASENAME

BASEDIR=${DIR%/*}
BASENAME=${DIR##*/}

if [ -z "$BASENAME" ]; then
    BASENAME="."
fi

cd $BASEDIR
find $BASENAME -type f ! -newermt $(date +"%Y-%m-%d" --date "2023-06-14") -print0
