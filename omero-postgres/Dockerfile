FROM postgres:9.3
MAINTAINER hadrien.mary@gmail.com

# Add sysadmin user
RUN echo 'sysadmin:x:1000:' >> /etc/group
RUN usermod -a -G sysadmin postgres

# Define some variables
ENV PG_VAR /var/lib/postgresql/9.3/main/
ENV PG_BIN /usr/lib/postgresql/9.3/bin/

ENV CONF $PG_VAR/postgresql.conf
ENV HBA $PG_VAR/pg_hba.conf
ENV INITDB $PG_BIN/initdb
ENV EXEC $PG_BIN/postgres

ENV PORT 5432

# Init database
RUN su postgres --command "$INITDB -D $PG_VAR"

# Allow PG to be accessed from any IP adress
RUN sed -i "/^#listen_addresses/i listen_addresses='*'" $CONF
RUN sed -i "/^# DO NOT DISABLE\!/i host all all 0.0.0.0/0 md5\n\n\n" $HBA

# Add start script
# TODO: use supervisor ?
RUN echo '"$EXEC" -p "$PORT" -D "$PG_VAR" -c config_file="$CONF"' >> /start.sh

# Add init script (for what purpose ?)
# RUN echo '$INITDB -D $PG_VAR' >> /init.sh

USER postgres

CMD ["sh", "start.sh"]
