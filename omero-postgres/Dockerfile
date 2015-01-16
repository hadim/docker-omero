FROM postgres:9.3
MAINTAINER hadrien.mary@gmail.com

# Define some variables
ENV PGDATA /var/lib/postgresql/data
ENV PGBIN /usr/lib/postgresql/9.3/bin/

ENV INITDB $PGBIN/initdb
ENV EXEC $PGBIN/postgres

ENV PORT 5432

# Add start script
RUN echo 'su postgres -c "'$EXEC' -p '$PORT' -D $PGDATA -c config_file=$PGDATA/postgresql.conf"' >> /start.sh

# Add init script
RUN echo "chown -R postgres "$PGDATA"" >> /init.sh
RUN echo 'su postgres -c "'$INITDB' -D $PGDATA"' >> /init.sh
RUN echo 'echo "'listen_addresses = \'*\''" >> $PGDATA/postgresql.conf' >> /init.sh
RUN echo 'echo "host all all 0.0.0.0/0 trust" >> $PGDATA/pg_hba.conf' >> /init.sh

RUN echo 'sysadmin:x:1000:' >> /etc/group
RUN usermod -a -G sysadmin postgres

CMD ["sh", "start.sh"]
