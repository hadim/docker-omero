# docker-omero

Set of `Dockerfile` to setup an OMERO.server. This project aims to be used in production.

_But the main purpose of this project is to make you love running OMERO.server :-)_

## How to start your OMERO.server

### Basics

Clone this repository :

```sh
git clone https://github.com/hadim/docker-omero.git
mkdir docker-omero/
```

You will need to install `docker-compose` (https://docs.docker.com/compose).

You __absolutely__ need to declare environment variables within the same shell as the one used to launch all `docker-compose` commands since `docker-compose` does not support (yet!) default variables during substitution (hope it will in a near future...).

```sh
export OMERO_WEB_PORT=80
export OMERO_WEB_PORT_SSL=443
export OMERO_SERVER_PORT=4064
export OMERO_WEB_PORT_DEVELOPMENT=4080
export OMERO_DATA_DIR=~/data
export OMERO_WEB_USE_SSL=yes
export OMERO_WEB_DEVELOPMENT=no

mkdir -p $OMERO_DATA_DIR
```

Then :

```sh
# Build base image (PR is welcome if you find a way to avoid this step)
docker build -t omero-base omero-base

# Build compose images
docker-compose build

# Start services
docker-compose up
```

It will launch all services : PostgreSQL server, OMERO.server and OMERO.web.

Wait a minute so the server can initialize. Then you can connect to OMERO with the [OMERO Insight client](http://downloads.openmicroscopy.org/latest/omero5). Or you can access via OMERO.web client at http://localhost:80.

Default admin credentials are `root` and `password`. Don't forget to change the password !

By default `~/data` will be used as OMERO data directoy. `80` is the default port for OMERO.web and `4064` is the default port for OMERO.server.

### Parameters

- `OMERO_WEB_PORT` (default=80) : port used to expose OMERO.web server in unsecure mode (`http`).

- `OMERO_WEB_PORT_SSL` (default=443) : port used to expose OMERO.web server in secure mode (`https`).

- `OMERO_SERVER_PORT` (default=4064) : port used to expose OMERO.server. This port needs to be used when using the desktop client (OMERO Insight client).

- `OMERO_WEB_PORT_DEVELOPMENT` (default=4080) : port used to expose OMERO.web server in development mode.

- `OMERO_DATA_DIR` (default=~/data) : data directory path on host used to store all data relative to OMERO.server.

- `OMERO_WEB_USE_SSL` (default=yes) : wether to launch OMERO.web with SSL mode (`https`), certificates are generated automatically or can be customized in `$OMERO_DATA_DIR/web_certs`.

- `OMERO_WEB_DEVELOPMENT` (default=no) : launch OMERO.web in development mode.

### Advanced usage

You can launch only OMERO.server (and the database server of course) with this command :

```sh
docker-compose run --rm --name omero-server omero-server
# or use
make runserver
```

If you want to launch OMERO.web in development mode you can use the following commands :

```sh
export OMERO_WEB_DEVELOPMENT=yes

docker-compose run --rm --name omero-web omero-web
# or use
make runweb
```

You can enter in an already running container (OMERO.server or OMERO.web) with the following commands :

```sh
# For OMERO.server
docker exec -ti omero-server bash
# or use
make shellserver

# and for OMERO.web
docker exec -ti omero-web bash
# or use
make shellweb
```

### Running OMERO.web in development mode

Coming soon !

## Log

`var` directory (which contains logs) is symlinked to `/data/omero_var` (`$OMERO_DATA_DIR/omero_var` on host).

```sh
$ make datash
$ ls omero_var/log/
Blitz-0.log        FileServer.log     MonitorServer.log  Processor-0.log    master.err
DropBox.log        Indexer-0.log      PixelData-0.log    Tables-0.log       master.out
```

## Backup and restore

You need to design a backup strategy according to your needs. All data needed to restart a server are located inside `OMERO_DATA_DIR` which is `~/data` by default.

The server will automatìcally use data inside `OMERO_DATA_DIR` on startup.

## About the images

**omero-base**: based on `ubuntu:14.04`, it contains omego and install OMERO.server.

**omero-data**: volume container based on `busybox`. `/data` is defined as a volume.

**omero-postgres**: based on `postgres:9.4`. It contains only few modifications from the original image.

**omero-server**: based on `omero-base`, it runs OMERO.server.

**omero-web**: based on `omero-base`, it runs OMERO.web.

See this schema for more details about how things are connected:

![Schema of docker-omero](schema.png)

## Authors

Hadrien Mary <hadrien.mary@gmail.com>

## License

MIT License. See [LICENSE](LICENSE).
