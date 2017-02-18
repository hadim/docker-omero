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

You will need to install `docker > 1.12.0` and `docker-compose >= 1.9.0` (check with `docker version`).

Then, build and start OMERO :

```sh
# Build base image.
# That would be nice to use Docker named volumes instead of data-only containers
# but I don't know how to deal with permissions.
docker build -t hadim/omero-base omero-base

# Build compose images
docker-compose build

# Start services
docker-compose up
```

It will launch all services : PostgreSQL server, OMERO.server and OMERO.web.

Wait a minute so the server can initialize.

To connect to the server with the [OMERO Insight client](http://downloads.openmicroscopy.org/latest/omero5) use `localhost` as a server address and `4064` (by default) for the port. You also need to enable the encrypted mode by clicking on the locker image on the login window.

To connect to the server with the OMERO.web client, go to http://localhost:80 or https://localhost:443 (by default).

Default admin credentials are `root` and `password`. Don't forget to change the password !

By default `~/data_omero` will be used as OMERO data directoy.


### Parameters

You can use environment variables to configure OMERO :

```sh
#export OMERO_WEB_PORT=80
#export OMERO_WEB_PORT_SSL=443
#export OMERO_SERVER_PORT=4064
#export OMERO_WEB_PORT_DEVELOPMENT=4080
#export OMERO_DATA_DIR=~/data_omero
#export OMERO_WEB_USE_SSL=yes
#export OMERO_WEB_DEVELOPMENT=no

mkdir -p $OMERO_DATA_DIR
```

- `OMERO_WEB_PORT` (default=80) : port used to expose OMERO.web server in unsecure mode (`http`).

- `OMERO_WEB_PORT_SSL` (default=443) : port used to expose OMERO.web server in secure mode (`https`).

- `OMERO_SERVER_PORT` (default=4064) : port used to expose OMERO.server. This port needs to be used when using the desktop client (OMERO Insight client).

- `OMERO_WEB_PORT_DEVELOPMENT` (default=4080) : port used to expose OMERO.web server in development mode.

- `OMERO_DATA_DIR` (default=~/data_omero) : data directory path on host used to store all data relative to OMERO.server.

- `OMERO_WEB_USE_SSL` (default=yes) : wether to launch OMERO.web with SSL mode (`https`), certificates are generated automatically or can be customized in `$OMERO_DATA_DIR/web_certs`.

- `OMERO_WEB_DEVELOPMENT` (default=no) : launch OMERO.web in development mode.

### Add custom applications to a server in production

Create a folder in `$OMERO_DATA_DIR/omero_web_apps`. Inside write a file called `deploy.sh` which will be called before launching the OMERO.web server. For example to install the figure application (http://figure.openmicroscopy.org), put this in `deploy.sh` :

```sh
export PYTHONPATH=$OMERO_WEB_DEVELOPMENT_APPS:$PYTHONPATH

pip install reportlab markdown
./bin/omero config append omero.web.apps '"figure"'
./bin/omero config append omero.web.ui.top_links '["Figure", "figure_index", {"title": "Open Figure in new tab", "target": "figure"}]'
```

Don't forget to download the application to `$OMERO_DATA_DIR/omero_web_apps`.

### Add custom configuration to a server in production

Edit or create the file `$OMERO_DATA_DIR/config.sh`. If it exists, it will be called before the server startup.

```sh
cat $OMERO_DATA_DIR/config.sh
./bin/omero config set omero.client.scripts_to_ignore '[]'
```

### Add custom scripts to a server in production

All scripts inside `$OMERO_DATA_DIR/omero_scripts` will be available inside your OMERO.server. Technically `$OMERO_DATA_DIR/omero_scripts` is soft linked to `lib/scripts/custom_scripts`.

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

## Running OMERO.web in development mode

### Developing an OMERO.web application

```sh
# Get OMERO.web shell and init the server
make runwebdev
su omero
bash /start_omero_web.sh
cd OMERO.server/
./bin/omero web start
```

You should now be able to connect to the dev server here `http://127.0.0.1:4080`.

Applications can be stored in `/data/omero_web_apps` (`$OMERO_DATA_DIR/omero_web_apps` on host).

Open a new shell.

```sh
make shellweb
su omero
cd OMERO.server/

./bin/omero config append omero.web.apps '"webtest"'
./bin/omero config append omero.web.ui.right_plugins '["ROIs", "webtest/webclient_plugins/right_plugin.rois.js.html", "image_roi_tab"]'
./bin/omero config append omero.web.ui.center_plugins '["Split View", "webtest/webclient_plugins/center_plugin.splitview.js.html", "split_view_panel"]'
```

In the first shell use `Ctrl+C` to stop the dev server.

```sh
export PYTHONPATH=$OMERO_WEB_DEVELOPMENT_APPS:$PYTHONPATH
./bin/omero web start
```

Your application should appear at http://localhost:4080/webtest.

### Developing on OMERO.web itself

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

You need to design a backup strategy according to your needs. All data needed to restart a server are located inside `OMERO_DATA_DIR` which is `~/data_omero` by default.

The server will automatìcally use data inside `OMERO_DATA_DIR` on startup.

## About the images

**omero-base**: based on `ubuntu:16.04`, it contains omego and install OMERO.server.

**omero-data**: volume container based on `busybox`. `/data` is defined as a volume.

**omero-db**: based on `postgres:9.4`. It contains only few modifications from the original image.

**omero-server**: based on `omero-base`, it runs OMERO.server.

**omero-web**: based on `omero-base`, it runs OMERO.web.

See this schema for more details about how things are connected:

![Schema of docker-omero](schema.png)

## Authors

Hadrien Mary <hadrien.mary@gmail.com>

## License

MIT License. See [LICENSE](LICENSE).
