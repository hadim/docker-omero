FROM omero-base

MAINTAINER hadrien.mary@gmail.com

USER omero

# Path variables
ENV OMERO_DATA_DIR /data/omero_data
ENV OMERO_VAR_DIR /data/omero_var

# Default password for admin user (root) of OMERO.server
ENV PASSWORD password

# Create script to init omero
RUN echo 'HOST="$PG_PORT_5432_TCP_ADDR"' >> $OMERO_DIR/init.sh
RUN echo 'PORT="$PG_PORT_5432_TCP_PORT"' >> $OMERO_DIR/init.sh
RUN echo 'cd $OMERO_HOME' >> $OMERO_DIR/init.sh
RUN echo 'if psql -h "$HOST" -p "$PORT" -U postgres -lqt | cut -d \| -f 1 | grep -w omero; then echo "Database already exist"; exit 1; fi' >> $OMERO_DIR/init.sh
RUN echo 'bin/omero db script "" "" "$PASSWORD" -f $OMERO_DIR/init_db.sql' >> $OMERO_DIR/init.sh
RUN echo 'createuser -h "$HOST" -p "$PORT" -U postgres -s omero' >> $OMERO_DIR/init.sh
RUN echo 'createdb -h "$HOST" -p "$PORT" -O omero omero' >> $OMERO_DIR/init.sh
RUN echo 'psql -h "$HOST" -p "$PORT" -U omero omero -f $OMERO_DIR/init_db.sql' >> $OMERO_DIR/init.sh
RUN echo 'rm -f $OMERO_DIR/init_db.sql' >> $OMERO_DIR/init.sh
RUN echo 'mkdir -p $OMERO_DATA_DIR' >> $OMERO_DIR/init.sh

# Create script to start omero and symlink OMERO.server/var to /data/omero_var
RUN echo 'if [ ! -d "$OMERO_DATA_DIR" ]; then sh $OMERO_DIR/init.sh; fi' >> $OMERO_DIR/start.sh
RUN echo 'cd $OMERO_HOME' >> $OMERO_DIR/start.sh
RUN echo 'mkdir -p $OMERO_VAR_DIR' >> $OMERO_DIR/start.sh
RUN echo 'rm -fr var' >> $OMERO_DIR/start.sh
RUN echo 'ln -s $OMERO_VAR_DIR var' >> $OMERO_DIR/start.sh
RUN echo 'bin/omero config set omero.db.host $PG_PORT_5432_TCP_ADDR' >> $OMERO_DIR/start.sh
RUN echo 'bin/omero config set omero.db.port $PG_PORT_5432_TCP_PORT' >> $OMERO_DIR/start.sh
RUN echo 'bin/omero config set omero.data.dir $OMERO_DATA_DIR' >> $OMERO_DIR/start.sh
RUN echo 'bin/omero admin start --foreground' >> $OMERO_DIR/start.sh

EXPOSE 4064

CMD ["sh", "start.sh"]
