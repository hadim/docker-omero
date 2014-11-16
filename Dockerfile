FROM ubuntu:14.04
MAINTAINER hadrien.mary@gmail.com

RUN apt-get update
RUN apt-get install -y unzip wget supervisor
RUN apt-get install -y postgresql
RUN apt-get install -y python2.7 python-pil python-matplotlib python-numpy python-tables python-scipy
RUN apt-get install -y openjdk-7-jre-headless ice-services python-zeroc-ice
RUN apt-get install -y mencoder

VOLUME ["/data"]

ADD . /omero_installation

RUN /omero_installation/setup-env.sh

USER omero
RUN /omero_installation/install-omero.sh

USER root
RUN /omero_installation/install-nginx.sh

COPY omero_supervisor.conf /etc/supervisor/conf.d/omero_supervisor.conf

EXPOSE 4063:4063 4064:4064 80:80

CMD ["/usr/bin/supervisord"]
