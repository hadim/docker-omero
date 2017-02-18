# Wait for data directory to be up
while [ ! -d $(dirname $PGDATA) ]
do
    echo "Waiting for $(dirname $PGDATA) directory to be up."
    sleep 5s;
done

if [ ! -d "$PGDATA" ]; then
    bash /init.sh;
fi

chmod -R 700 $PGDATA
su postgres -c "$EXEC -p $PORT -D $PGDATA -c config_file=$PGDATA/postgresql.conf"
