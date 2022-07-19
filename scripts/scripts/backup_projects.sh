#!/bin/bash

Color_off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue

TODAY=`date +"%Y%m%d"`
# OLDBACKUP=`date -d "7 days ago" +"%Y%m%d"`
EXCLUDES="$HOME/.backup/exclude.txt"

BACKUP_PATH="$HOME/.backup"
CLOUD_PATH="$HOME/yandex.disk"
CLOUD_FOLDER="rpiBackupProjects"

PRJ_PATHS=("$HOME/Documents/PlatformIO/Projects" "$HOME/Developer") 

need_cmd () {
    if ! hash "$1" &>/dev/null; then
        error "Need '$1' (command not found)"
        exit 1
    fi
}

msg() {
    printf '%b\n' "$1" >&2
}

success() {
    msg "${Green}[✔]${Color_off} ${1}${2}"
}

info() {
    msg "${Blue}[➭]${Color_off} ${1}${2}"
}

error() {
    msg "${Red}[✘]${Color_off} ${1}${2}"
    exit 1
}

warn () {
    msg "${Yellow}[⚠]${Color_off} ${1}${2}"
}

echo_with_color () {
    printf '%b\n' "$1$2$Color_off" >&2
}


create_backup_archive () {
    if [ -f $BACKUP_PATH/*.back ]; then
        rm $BACKUP_PATH/*.back
    fi

    for file in $BACKUP_PATH/*.bz2; do
        if [ -f $file ]; then
            mv $file $file.back
        fi
    done

    tar --exclude-from=$EXCLUDES \
        -jcvf \
        $BACKUP_PATH/"$TODAY.tar.bz2" \
        ${PRJ_PATHS[@]} > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        success "Backup done"
    else
        error "Backup error"
        exit 0
    fi
}

sync_cloud () {
    wget -q --tries=5 --timeout=10 --spider http://yandex.ru
    if [[ $? -eq 0 ]]; then
        systemctl --type=mount | grep $CLOUD_PATH > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            if [ ! -d $CLOUD_PATH/$CLOUD_FOLDER ]; then
                info "Backup folder not found in the cloud. Creating..."
                mkdir $CLOUD_PATH/$CLOUD_FOLDER
            fi
            rsync -az --delete \
                $BACKUP_PATH/* \
                $CLOUD_PATH/$CLOUD_FOLDER
        
            if [ $? -eq 0 ]; then
                success "Backup sync with the cloud done"
            else
                warn "Backup sync with the cloud error!"
                exit 0
            fi
            
        else
            error "Cloud disk is not mounted!"
            exit 0
        fi
    else
        warn "No Internet"
    fi

}

main () {
    if [ ! -d $BACKUP_PATH ]; then
        error "Backup folder not found!"
        exit 0
    fi

    create_backup_archive
    sync_cloud
}

main $@
