#! /bin/bash

IFS="
"
if [[ -z ${1} ]]; then 
	DIR="."
else
	DIR=${1}
fi

find ${DIR} -newermt $(date +"%Y-%m-%d" --date "2023-06-13") -print
