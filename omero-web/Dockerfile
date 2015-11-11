FROM omero-base

MAINTAINER hadrien.mary@gmail.com

ENV OMERO_WEB_CERTS_DIR /data/web_certs

RUN apt-get install -y nginx-full supervisor python-pip openssl

RUN pip install -r $OMERO_HOME/share/web/requirements-py27-nginx.txt
COPY nginx_omero.conf $OMERO_HOME/nginx.conf.tmp

USER root
RUN mv $OMERO_HOME/nginx.conf.tmp /etc/nginx/sites-available/omero-web
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/omero-web /etc/nginx/sites-enabled/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80
EXPOSE 443

COPY supervisor.conf /supervisor.conf
COPY start.sh /start.sh
RUN chown omero /start.sh

CMD ["/usr/bin/supervisord", "-c", "/supervisor.conf", "-e", "info"]
