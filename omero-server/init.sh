HOST="$OMERO_PG_PORT_5432_TCP_ADDR"
PORT="$OMERO_PG_PORT_5432_TCP_PORT"

mkdir -p $OMERO_VAR_DIR/
mkdir -p $OMERO_DATA_DIR/

cd $OMERO_HOME/

if psql -h "$HOST" -p "$PORT" -U postgres -lqt | cut -d \| -f 1 | grep -w omero; then
    echo "Database already exist";
    exit 0;
fi

./bin/omero db script "" "" "$PASSWORD" -f $OMERO_DIR/init_db.sql
createuser -h "$HOST" -p "$PORT" -U postgres -s omero
createdb -h "$HOST" -p "$PORT" -O omero omero
psql -h "$HOST" -p "$PORT" -U omero omero -f $OMERO_DIR/init_db.sql
rm -f $OMERO_DIR/init_db.sql
