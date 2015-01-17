FROM ubuntu:14.04

MAINTAINER hadrien.mary@gmail.com

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip wget supervisor \
    python2.7 python-pil python-matplotlib python-pip \
    python-numpy python-tables python-scipy \
    openjdk-7-jre-headless ice35-services python-zeroc-ice \
    mencoder nano postgresql-client-9.3

ENV BRANCH OMERO-5.1-latest
ENV LABEL ICE=3.5

# Path variables
ENV OMERO_DIR /omero
ENV OMERO_HOME $OMERO_DIR/OMERO.server

# Add omero user and install omego tools
RUN useradd -m omero
RUN pip install -U omego

RUN mkdir $OMERO_DIR
RUN chown omero $OMERO_DIR

# Download and install omero with omego
USER omero
WORKDIR $OMERO_DIR
RUN omego download --branch=$BRANCH server --labels $LABEL
RUN rm OMERO.server*zip
RUN ln -s OMERO.server* $OMERO_HOME

USER root
