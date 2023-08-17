#! /bin/bash

IFS="
"
if [[ $1 == "" ]]; then 
	DIR="."
else
	DIR=${1}
fi

echo $DIR

find $DIR -type f ! -newermt $(date +"%Y-%m-%d" --date "2023-06-14")
