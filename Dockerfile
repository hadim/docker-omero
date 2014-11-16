FROM ubuntu:14.04
MAINTAINER Hadrien Mary <hadrien.mary@gmail.com>

RUN apt-get update && apt-get install -y \
    unzip wget supervisor \
    postgresql \
    python2.7 python-pil python-matplotlib \
    python-numpy python-tables python-scipy \
    openjdk-7-jre-headless ice-services python-zeroc-ice \
    mencoder \

ADD . /omero_installation
RUN /omero_installation/setup-env.sh

USER omero
RUN /omero_installation/install-omero.sh

USER root
RUN /omero_installation/setup-database.sh
RUN /omero_installation/install-nginx.sh

VOLUME ["/data", "/home/omero/OMERO.server/var", \
        "/var/log/postgresql", "/var/lib/postgresql"]

COPY omero_supervisor.conf /etc/supervisor/conf.d/omero_supervisor.conf

EXPOSE 4063 4064 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/omero_supervisor.conf"]
