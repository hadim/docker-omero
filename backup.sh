#!/usr/bin/env sh

if [ ! -z $1 ]
then
    BACKUP_DIR=$1
else
    BACKUP_DIR=$HOME/omero_backup
fi

BACKUP_NAME=$(date +%Y_%m_%d_%H_%M_omero.tar)

docker run --rm=true --volumes-from data -v $BACKUP_DIR:/tmp ubuntu tar -cvf /tmp/$BACKUP_NAME /data
