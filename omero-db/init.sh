mkdir $PGDATA
chown -R postgres "$PGDATA"

su postgres -c "'$INITDB' -D $PGDATA"

echo "listen_addresses='*'" >> $PGDATA/postgresql.conf
echo "host all all 0.0.0.0/0 trust" >> $PGDATA/pg_hba.conf
