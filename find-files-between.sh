#! /bin/bash

IFS="
"
if [[ $1 == "" ]]; then 
	DIR="."
else
	DIR=${1}
fi

echo $DIR

find $DIR -type f -newermt $(date +"%Y-%m-%d %H:%M" --date "2023-06-14 00:00") ! -newermt $(date +"%Y-%m-%d %H:%M" --date "2023-06-15 05:30")
