FROM omero-base

MAINTAINER hadrien.mary@gmail.com

RUN apt-get install -y nginx supervisor

## Setup nginx
USER omero
RUN $OMERO_HOME/bin/omero web config nginx --system --http 80 > $OMERO_HOME/nginx.conf.tmp

USER root
RUN mv $OMERO_HOME/nginx.conf.tmp /etc/nginx/sites-available/omero-web
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/omero-web /etc/nginx/sites-enabled/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Create script to start omero and symlink OMERO.server/var to /data/omero_var
RUN echo 'cd $OMERO_HOME' >> $OMERO_DIR/start.sh
RUN echo 'bin/omero config set omero.web.server_list "[[\"$OMERO_SERVER_PORT_4064_TCP_ADDR\", 4064, \"omero\"]]"' >> $OMERO_DIR/start.sh
RUN echo 'bin/omero web start' >> $OMERO_DIR/start.sh
RUN chown omero $OMERO_DIR/start.sh

EXPOSE 80

COPY supervisor.conf $OMERO_DIR/supervisor.conf

CMD ["/usr/bin/supervisord", "-c", "/omero/supervisor.conf", "-e", "info"]
