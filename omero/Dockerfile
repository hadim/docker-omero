FROM ubuntu:14.04

MAINTAINER hadrien.mary@gmail.com

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip wget supervisor \
    python2.7 python-pil python-matplotlib python-pip \
    python-numpy python-tables python-scipy \
    openjdk-7-jre-headless ice35-services python-zeroc-ice \
    mencoder nano postgresql-client-common

ENV BRANCH OMERO-5.1-latest
ENV LABEL ICE=3.5

# Path variables
ENV OMERO_DATA_DIR /data/omero_data
ENV OMERO_DIR /omero
ENV OMERO_HOME $OMERO_DIR/OMERO.server

# Default omero password
ENV PASSWORD omero

RUN useradd -m omero
RUN pip install -U omego

RUN mkdir $OMERO_DIR
RUN chown omero $OMERO_DIR

USER omero
WORKDIR $OMERO_DIR
RUN omego download --branch=$BRANCH server --labels $LABEL
RUN rm OMERO.server*zip
RUN ln -s OMERO.server* $OMERO_HOME

RUN echo 'cd $OMERO_HOME' >> /start.sh
RUN echo 'bin/omero config set omero.db.host $PG_PORT_5432_TCP_ADDR' >> $OMERO_DIR/start.sh
RUN echo 'bin/omero config set omero.db.port $PG_PORT_5432_TCP_PORT' >> $OMERO_DIR/start.sh
RUN echo 'bin/omero config set omero.data.dir $OMERO_DATA_DIR' >> $OMERO_DIR/start.sh

RUN echo 'HOST="$PG_PORT_5432_TCP_ADDR"' >> $OMERO_DIR/init.sh
RUN echo 'PORT="$PG_PORT_5432_TCP_PORT"' >> $OMERO_DIR/init.sh
RUN echo 'cd $OMERO_HOME' >> $OMERO_DIR/init.sh
RUN echo 'bin/omero db script "" "" "$PASSWORD" -f /init_db.sql' >> $OMERO_DIR/init.sh
RUN echo 'createuser -h "$HOST" -p "$PORT" -U postgres -s omero' >> $OMERO_DIR/init.sh
RUN echo 'createdb -h "$HOST" -p "$PORT" -O omero omero' >> $OMERO_DIR/init.sh
RUN echo 'psql -h "$HOST" -p "$PORT" -U omero omero -f /init_db.sql' >> $OMERO_DIR/init.sh
RUN echo 'rm -f /init_db.sql' >> $OMERO_DIR/init.sh

CMD ["sh", "start.sh"]
