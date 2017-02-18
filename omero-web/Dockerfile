FROM frolvlad/alpine-glibc:alpine-3.5_glibc-2.25

MAINTAINER hadrien.mary@gmail.com

# Install dependencies
RUN apk update && apk upgrade && apk add --update wget ca-certificates && \
    apk add py-pip bash nginx supervisor openssl gcc g++ bzip2-dev openssl-dev

# Install conda
ENV CONDA_DIR="/conda"
ENV CONDA_VERSION="4.3.11"

RUN mkdir -p "$CONDA_DIR" && \
    wget "http://repo.continuum.io/miniconda/Miniconda2-${CONDA_VERSION}-Linux-x86_64.sh" -O miniconda.sh && \
    bash miniconda.sh -f -b -p "$CONDA_DIR" && \
    echo "export PATH=$CONDA_DIR/bin:\$PATH" >> /etc/profile.d/conda.sh && \
    rm miniconda.sh && \
    $CONDA_DIR/bin/conda update --all --yes && \
    $CONDA_DIR/bin/conda config --set auto_update_conda False && \
    $CONDA_DIR/bin/conda clean --all --yes

# Install python packages
RUN $CONDA_DIR/bin/conda install --yes numpy matplotlib pytables scipy pillow
RUN $CONDA_DIR/bin/pip install omego zeroc-ice

ENV OMERO_WEB_CERTS_DIR /data/web_certs
ENV OMERO_WEB_USE_SSL yes
ENV OMERO_WEB_DEVELOPMENT no
ENV OMERO_WEB_DEVELOPMENT_APPS /data/omero_web_apps

RUN $CONDA_DIR/bin/pip install -r $OMERO_HOME/share/web/requirements-py27-nginx.txt
RUN $CONDA_DIR/bin/pip install django-debug-toolbar
COPY nginx_omero.conf $OMERO_HOME/nginx_omero.conf
COPY nginx_omero_ssl.conf $OMERO_HOME/nginx_omero_ssl.conf

USER root
RUN rm /etc/nginx/sites-enabled/default
RUN mv $OMERO_HOME/nginx_omero.conf /etc/nginx/sites-available/nginx_omero.conf
RUN mv $OMERO_HOME/nginx_omero_ssl.conf /etc/nginx/sites-available/nginx_omero_ssl.conf

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

COPY supervisor.conf /supervisor.conf
COPY start_nginx.sh /start_nginx.sh
COPY start_omero_web.sh /start_omero_web.sh
RUN chown omero /start_omero_web.sh

EXPOSE 80
EXPOSE 443

CMD ["bash", "-l", "/usr/bin/supervisord", "-c", "/supervisor.conf", "-e", "info"]
