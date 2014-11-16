#!/usr/bin/env sh

. /omero_installation/setup-vars.sh

# Start database
service postgresql start

# Add 'omero' user
useradd -m omero
chmod a+X ~omero

mkdir -p "$OMERO_DATA_DIR"
chown omero:omero "$OMERO_DATA_DIR"

# Configure database
echo "CREATE USER $OMERO_DB_USER PASSWORD '$OMERO_DB_PASS'" | su - postgres -c psql
su - postgres -c "createdb -O '$OMERO_DB_USER' '$OMERO_DB_NAME'"
psql -P pager=off -h localhost -U "$OMERO_DB_USER" -l
