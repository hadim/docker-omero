FROM frolvlad/alpine-glibc:alpine-3.5

MAINTAINER hadrien.mary@gmail.com

# Install dependencies
RUN apk update && apk upgrade && apk add --update wget ca-certificates && \
    apk add unzip openjdk8 postgresql postgresql-client bash python

# Path variables
ENV OMERO_DIR /omero
ENV OMERO_HOME $OMERO_DIR/OMERO.server

ENV OMERO_DATA_DIR /data/omero_data
ENV OMERO_VAR_DIR /data/omero_var
ENV OMERO_SCRIPTS_DIR /data/omero_scripts

# Create OMERO directory
RUN mkdir $OMERO_DIR && adduser omero -D && chown omero $OMERO_DIR
USER omero
WORKDIR $OMERO_DIR

# Download Omero
ENV OMERO_VERSION 5.2.7
ENV ICE_VERSION 35
RUN wget http://downloads.openmicroscopy.org/omero/${OMERO_VERSION}/artifacts/OMERO.server-${OMERO_VERSION}-ice${ICE_VERSION}-b40.zip
RUN unzip OMERO.server*zip
RUN rm OMERO.server*zip
RUN ln -s OMERO.server-* $OMERO_HOME

# Default password for admin user (root) of OMERO.server
ENV PASSWORD password

COPY start.sh /start.sh
COPY init.sh /init.sh

EXPOSE 4064

CMD ["bash", "-l", "/start.sh"]
