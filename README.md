# docker-omero

Docker file to build OMERO server. Largely inspired form http://www.openmicroscopy.org/site/support/omero5/sysadmins/unix/server-linux-walkthrough.html.

## Install

You can pull or build the docker image :

```
docker pull hadim/docker-omero
# or
docker build -t hadim/docker-omero github.com/hadim/docker-omero
```

## Usage

To launch an OMERO instance, run the container :

```
docker run -p 4064:4064 -p 4063:4063 -p 8080:80 --name omero -t hadim/docker-omero
```

You should be able to connect with OMEROinsight client or via webserver at http://localhost:8080. Default password for user `root` is `password`.

However OMERO data folder resides into the container and so will be deleted once the container is removed. To keep data folder permanently, you have to bind it to an host folder for example `~/omero_data`.

```
docker run -p 4064:4064 -p 4063:4063 -p 8080:80 --name omero -v ~/omero_data:/data -t hadim/docker-omero
```

## Database backup

Automatic backup of database is made every day via cron. Backups are stored to `/data/backups` with a script located in the container `/etc/cron.daily/backup-omero-database.sh`. To launch a manual backup, you can use :

```
# omero is the name of the running container
docker exec -ti omero /etc/cron.daily/backup-omero-database.sh
```

## Restore OMERO.server

You can restore an OMERO.server by binding an already populated data folder and restoring a backup database :

```
docker run -p 4064:4064 -p 4063:4063 -p 8080:80 --name omero -v ~/omero_data:/data -t hadim/docker-omero --restore /data/backups/2014_11_18_09_35_omero_db.tar.bz2
```

Note that path to compressed backup is relative to container.

You can also ask to restore the last found backup in `/data/backups`:

```
docker run -p 4064:4064 -p 4063:4063 -p 8080:80 --name omero -v ~/omero_data:/data -t hadim/docker-omero --restore-last
```

## TODO

- add a system to use external database

## Authors

Hadrien Mary <hadrien.mary@gmail.com>

## License

MIT License. See [LICENSE](LICENSE).
