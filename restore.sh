#!/usr/bin/env sh

if [ ! -z $1 ]
then
    BACKUP_FILE=$1
else
    echo "You must specify a backup file (.tar.bz2) to restore."
    exit 1
fi

BACKUP_DIR=$(dirname $BACKUP_FILE)
BACKUP_NAME=$(basename $BACKUP_FILE)

docker run --name data omero-data true && docker run --rm=true --volumes-from data -v $BACKUP_DIR:/tmp ubuntu tar xjvf /tmp/$BACKUP_NAME
