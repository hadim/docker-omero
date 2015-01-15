FROM ubuntu:14.04

MAINTAINER hadrien.mary@gmail.com

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip wget supervisor \
    python2.7 python-pil python-matplotlib python-pip \
    python-numpy python-tables python-scipy \
    openjdk-7-jre-headless ice35-services python-zeroc-ice \
    mencoder nano

ENV BRANCH OMERO-5.1-latest
ENV LABEL ICE=3.5

# Path variables
ENV OMERO_DATA_DIR /data
ENV OMERO_DIR /omero
ENV OMERO_HOME $OMERO_DIR/OMERO.server
ENV OMERO_BIN $OMERO_HOME/bin/omero

RUN useradd -m omero
RUN pip install -U omego

RUN mkdir /omero
RUN mkdir /data
RUN chown omero /omero

USER omero
WORKDIR /omero
RUN omego download --branch=$BRANCH server --labels $LABEL
RUN rm OMERO.server*zip
RUN ln -s OMERO.server* $OMERO_HOME

RUN $OMERO_BIN config set omero.data.dir "$OMERO_DATA_DIR"
RUN $OMERO_BIN config set omero.db.host "$PG_PORT_5432_TCP_ADDR"
RUN $OMERO_BIN config set omero.db.port "$PG_PORT_5432_TCP_PORT"
