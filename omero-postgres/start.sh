if [ ! -d "$PGDATA" ]; then
    bash /init.sh;
fi

chmod -R 700 $PGDATA
su postgres -c "$EXEC -p $PORT -D $PGDATA -c config_file=$PGDATA/postgresql.conf"
