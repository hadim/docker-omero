FROM omero-base

MAINTAINER hadrien.mary@gmail.com

ENV OMERO_WEB_CERTS_DIR /data/web_certs
ENV OMERO_WEB_USE_SSL yes
ENV OMERO_WEB_DEVELOPMENT no
ENV OMERO_WEB_DEVELOPMENT_APPS /data/omero_web_apps

RUN apt-get install -y nginx-full supervisor python-pip openssl

RUN pip install -r $OMERO_HOME/share/web/requirements-py27-nginx.txt
COPY nginx_omero.conf $OMERO_HOME/nginx_omero.conf
COPY nginx_omero_ssl.conf $OMERO_HOME/nginx_omero_ssl.conf

USER root
RUN rm /etc/nginx/sites-enabled/default
RUN mv $OMERO_HOME/nginx_omero.conf /etc/nginx/sites-available/nginx_omero.conf
RUN mv $OMERO_HOME/nginx_omero_ssl.conf /etc/nginx/sites-available/nginx_omero_ssl.conf

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80
EXPOSE 443
EXPOSE 4080

COPY supervisor.conf /supervisor.conf
COPY start_nginx.sh /start_nginx.sh
COPY start_omero_web.sh /start_omero_web.sh
RUN chown omero /start_omero_web.sh

CMD ["/usr/bin/supervisord", "-c", "/supervisor.conf", "-e", "info"]
