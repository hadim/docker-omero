# docker-omero

Set of Dockerfile to setup an OMERO.server. This project aims to be used in production.

## How to start your OMERO.server (with OMERO.web)

Clone this repo :

```sh
git clone https://github.com/hadim/docker-omero.git
```

Then start the server :

```sh
make initdatahost
make start
```

Wait a minute so the server initialize. Then you can connect to OMERO with the [OMERO Insight client](http://downloads.openmicroscopy.org/latest/omero5). Or you can access via OMERO.web client at http://localhost:8080. Default admin credentials are `root` and `password`. Don't forget to change the password !

By default `~/data` will be used as OMERO data directoy. `8080` is the default port for OMERO.web and `4064` is the default port for OMERO.server.

To change this behaviour you can do the following :

```sh
make OMERO_DATA_DIR=/var/data/my_custom_data_location initdatahost
make start
```

If you want to stop and remove OMERO.server, use :

```sh
make rm
```

You can also start OMERO without data directory mounted on host by using `make initdata` instead of `make initdatahost`.

To start a shell in the data container :

```sh
make datash
```

In the OMERO.server :

```sh
make omerosh
```


In the PGSQL server :

```sh
make pgsh
```

## Log

`var` directory (which contains logs) is symlinked to `/data/omero_var`.

```sh
$ make datash
# ls omero_var/log/
Blitz-0.log        FileServer.log     MonitorServer.log  Processor-0.log    master.err
DropBox.log        Indexer-0.log      PixelData-0.log    Tables-0.log       master.out
```

## Backup and restore

You need to design a backup strategy according to your needs. All data needed to restart a server are located inside `OMERO_DATA_DIR` which is `~/data` by default.

The server will automatìcally use data inside `OMERO_DATA_DIR` on startup.

## Docker-compose support

For now `docker-compose` does not seem flexible enough to be used here. PR are welcome !

## About the images

**omero-base**: based on ubuntu 14.04, it contains omego and install OMERO.server.

**omero-data**: volume container based on busybox. `/data` is defined as a volume.

**omero-postgres**: based on postgres:9.3. It contains only few modifications from the original image.

**omero-server**: based on omero-base, it runs OMERO.server.

**omero-web**: based on omero-base, it runs OMERO.web.

See this schema for more details about how things are connected:

![Schema of docker-omero](schema.png)

## Authors

Hadrien Mary <hadrien.mary@gmail.com>

## License

MIT License. See [LICENSE](LICENSE).
