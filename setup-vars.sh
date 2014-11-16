#!/usr/bin/env sh

export OMERO_DB_USER="omero"
export OMERO_DB_PASS="omero_password"
export OMERO_DB_NAME="omero"
export OMERO_ROOT_PASS="omero_root_password"
export OMERO_DATA_DIR="/data"
export OMERO_WEB_PORT="80"
export PGPASSWORD="$OMERO_DB_PASS"
export OMERO_SERVER="http://downloads.openmicroscopy.org/omero/5.0.6/artifacts/OMERO.server-5.0.6-ice35-b53.zip"
