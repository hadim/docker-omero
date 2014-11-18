FROM ubuntu:14.04
MAINTAINER Hadrien Mary <hadrien.mary@gmail.com>

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip wget supervisor \
    postgresql nginx \
    python2.7 python-pil python-matplotlib \
    python-numpy python-tables python-scipy \
    openjdk-7-jre-headless ice-services python-zeroc-ice \
    mencoder

# Setup variables
ENV OMERO_DB_USER omero
ENV OMERO_DB_PASS omero_password
ENV OMERO_DB_NAME omero
ENV OMERO_ROOT_PASS password
ENV OMERO_DATA_DIR /data
ENV OMERO_WEB_PORT 80
ENV OMERO_VERSION 5.0.6
ENV OMERO_SERVER http://downloads.openmicroscopy.org/omero/${OMERO_VERSION}/artifacts/OMERO.server-${OMERO_VERSION}-ice35-b53.zip
ENV OMERO_DIR /home/omero
ENV OMERO_HOME $OMERO_DIR/OMERO.server
ENV OMERO_BIN $OMERO_HOME/bin/omero

# Setup environment
RUN useradd -m omero
RUN chmod a+X ~omero
RUN mkdir -p "$OMERO_DATA_DIR"
RUN chown omero:omero "$OMERO_DATA_DIR"

# Install Omero
USER omero
RUN wget -P $OMERO_DIR $OMERO_SERVER
RUN unzip -q $OMERO_DIR/$(basename $OMERO_SERVER) -d $OMERO_DIR
RUN ln -s $OMERO_DIR/$(basename "${OMERO_SERVER%.zip}") $OMERO_HOME

# Setup Omero.server
RUN $OMERO_BIN config set omero.data.dir "$OMERO_DATA_DIR"
RUN $OMERO_BIN config set omero.db.name "$OMERO_DB_NAME"
RUN $OMERO_BIN config set omero.db.user "$OMERO_DB_USER"
RUN $OMERO_BIN config set omero.db.pass "$OMERO_DB_PASS"
RUN $OMERO_BIN db script -f $OMERO_HOME/db.sql "" "" "$OMERO_ROOT_PASS"
RUN $OMERO_BIN web config nginx --system --http "$OMERO_WEB_PORT" > $OMERO_HOME/nginx.conf.tmp

# Setup database
USER root
RUN service postgresql start && su postgres -c "psql postgres -c \"CREATE USER $OMERO_DB_USER PASSWORD '$OMERO_DB_PASS'\"" && service postgresql stop
RUN service postgresql start && su postgres -c "createdb -O '$OMERO_DB_USER' '$OMERO_DB_NAME'" && service postgresql stop
RUN service postgresql start && PGPASSWORD="$OMERO_DB_PASS" psql -h localhost -U "$OMERO_DB_USER" "$OMERO_DB_NAME" < $OMERO_HOME/db.sql && service postgresql stop

# Install Omero.web with nginx
RUN cp $OMERO_HOME/nginx.conf.tmp /etc/nginx/sites-available/omero-web
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/omero-web /etc/nginx/sites-enabled/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Copy supervisor configuration
COPY omero_supervisor.conf /etc/supervisor/conf.d/omero_supervisor.conf

# Copy database backup script
COPY backup-omero-database.sh /etc/cron.daily/backup-omero-database.sh

# Copy omero startup script
COPY start-omero-server.py /start-omero-server.py

VOLUME [$OMERO_DATA_DIR]

EXPOSE 4063 4064 80

ENTRYPOINT ["/start-omero-server.py"]
