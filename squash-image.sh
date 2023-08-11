#! /bin/bash

##################################
# main function
##################################
if [[ $EUID -ne 0 ]];
then
    exec sudo /bin/bash "$0" "$USER" "$@"
    exit 0
fi

IFS="
"

USER=$1 
if [[ $USER == "" ]] ;
then
 USER="ubuntu"
fi

BASE_DIR=$(dirname $0)
WORKING_DIR="${BASE_DIR}/.."
IMAGE_DIR="${WORKING_DIR}/images"

# nach Hostnamen fragen
echo "What's the hostname of this machine?"
read HOSTNAME

# Informationen zu den verbauten Disk ermitteln ...
DISK_DEV=$(LANG=C; fdisk -l | grep "^Disk /dev/[h|s|n]" | awk -F, '{ print $1 }' | awk -F" " '{ print $2 " " $3 " " $4}' | tr ":" " ")
DISK_MODEL=$(LANG=C; fdisk -l | grep "^Disk model" | awk -F: '{ print $2 }' | sed -e 's/[[:space:]]*$//')

for model in ${DISK_MODEL}; do DISK_MODELS+=(${model}); done;
for fdisk in ${DISK_DEV}; do DISKS+=(${fdisk}); done

# ... und in ein Auswahlmenu aufnehmen
for i in $(seq 1 ${#DISKS[@]}); do MENU+=(${DISKS[i-1]}${DISK_MODELS[i-1]}); done;

# Menu anzeigen, multiple Auswahl ist möglich
while true; do
    clear
    echo ""
    echo Disks installed:
    PS3="Please (un-)select disks for imaging:"
    select DISK in "${MENU[@]}" "continue"
    do
        case $REPLY in
            $((${#DISKS[@]}+1))) echo "continue..."; break 2;;
            *)  if [[ $DISK != "" ]]; then
                    if [[ $DISK != *"(*)" ]]; then
                        MENU[$REPLY-1]="$DISK (*)"
                    else
                        MENU[$REPLY-1]="${DISKS[$REPLY-1]}${DISK_MODELS[$REPLY-1]}"
                    fi
                    break 
                else
                    break
                fi
        esac
    done
done

# Menuauswahl selektieren
for i in $(seq 1 ${#MENU[@]})
do
    if [[ ${MENU[i-1]} == *"(*)" ]]; then
        SELECTED_DISK+=($(echo ${MENU[i-1]} | awk -F" " '{print $1}'))
    fi
done

# Zusammenfassung anzeigen und Prozess starten
if [[ ${#SELECTED_DISK[@]} -gt 0 ]]; then
    fdisk -l ${SELECTED_DISK[@]}
    while true; do
        read -p "Do you wish to image this disk(s) to ${IMAGE_DIR}/${HOSTNAME} [y|n]? " yn
        case $yn in
            [Yy]* ) 
            	    chmod 777 "$WORKING_DIR"
                    mkdir -p -m 777 "${IMAGE_DIR}/${HOSTNAME}"
                    cd "${IMAGE_DIR}/${HOSTNAME}"
                    $(pwd)/../../scripts/hzb_pc_info.sh
                    
                    # ausgewählte Disk parsen und Partitionen ermitteln
                    for i in $(seq 1 ${#SELECTED_DISK[@]})
                    do
                        for partition in $(LANG=C; fdisk -l ${SELECTED_DISK[i-1]} | grep "^/dev/[h|s|n]" | awk -F" " '{ print $1 }')
                        do
                             PART+=($partition)
                        done
                    done
                    $(pwd)/../../scripts/hzb_mk_image.sh ${PART[@]}
                    break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done

else
    echo "Nothing to do...abort"
    exit
fi

exit 0


