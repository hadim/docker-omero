#!/usr/bin/env sh

. /omero_installation/setup-vars.sh

# Add 'omero' user
useradd -m omero
chmod a+X ~omero

mkdir -p "$OMERO_DATA_DIR"
chown omero:omero "$OMERO_DATA_DIR"
