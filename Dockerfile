FROM ubuntu:14.04
MAINTAINER Hadrien Mary <hadrien.mary@gmail.com>

RUN apt-get update
RUN apt-get install -y unzip wget supervisor
RUN apt-get install -y postgresql
RUN apt-get install -y python2.7 python-pil python-matplotlib python-numpy python-tables python-scipy
RUN apt-get install -y openjdk-7-jre-headless ice-services python-zeroc-ice
RUN apt-get install -y mencoder

ADD . /omero_installation
RUN /omero_installation/setup-env.sh

USER omero
COPY OMERO.server-5.0.6-ice35-b53.zip /home/omero/OMERO.server-5.0.6-ice35-b53.zip
RUN /omero_installation/install-omero.sh

USER root
RUN /omero_installation/setup-database.sh
RUN /omero_installation/install-nginx.sh

VOLUME ["/data", "/home/omero/OMERO.server/var", \
        "/var/log/postgresql", "/var/lib/postgresql"]

COPY omero_supervisor.conf /etc/supervisor/conf.d/omero_supervisor.conf

EXPOSE 4063 4064 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/omero_supervisor.conf"]
