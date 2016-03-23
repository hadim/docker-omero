# Wait for data directory to be up
while [ ! -d $(dirname $OMERO_DATA_DIR) ]
do
    echo "Waiting for $(dirname $OMERO_DATA_DIR) directory to be up."
    sleep 5s;
done

HOST="omero-db"
PORT="5432"

# Wait for PG server to be up
while ! pg_isready -h $HOST -p $PORT -d omero -U omero --quiet; do
    echo "Waiting for database server to be up."
    sleep 5s;
done

# Init the database for OMERO.server if data dir does not exist
if [ ! -d "$OMERO_DATA_DIR" ]; then
    bash /init.sh || (echo "Something failed during the initialisation"; exit 1);
fi

cd $OMERO_HOME/

if [ -f "/data/config.sh" ]; then
    bash /data/config.sh || (echo "Something failed during the config.sh"; exit 1);
fi

mkdir -p $OMERO_SCRIPTS_DIR/
ln -s $OMERO_SCRIPTS_DIR/ lib/scripts/custom_scripts

rm -fr var/
ln -s $OMERO_VAR_DIR var

./bin/omero config set omero.db.host $HOST
./bin/omero config set omero.db.port $PORT
./bin/omero config set omero.data.dir $OMERO_DATA_DIR
./bin/omero admin start --foreground
