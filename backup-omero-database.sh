#!/usr/bin/env sh

BACKUP_DIR="/data/backups"
OMERO_DB_USER="omero"
OMERO_DB_PASS="omero_password"
OMERO_DB_NAME="omero"
FNAME=$(date +"%Y_%m_%d_%H_%M_omero_db.tar.bz2")

mkdir -p $BACKUP_DIR

# Remove backups older than 7 days
find $BACKUP_DIR -type f -mtime +7 -exec rm {} \;

# Dump database
su postgres -c "pg_dump -Fc -f /tmp/omero_db.pg_dump $OMERO_DB_NAME"

# Compress it
cd /tmp
tar -jcvf $BACKUP_DIR/$FNAME omero_db.pg_dump

# Remove uncompressed db
rm -fr /tmp/omero_db.pg_dump

# Give permissions
chown omero:omero $BACKUP_DIR/$FNAME
