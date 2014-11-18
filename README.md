# docker-omero

Docker file to build omero server. Largely inspired form http://www.openmicroscopy.org/site/support/omero5/sysadmins/unix/server-linux-walkthrough.html.

## Install and use

You can pull or build the docker image :

```
docker pull hadim/docker-omero
# or
docker build -t hadim/docker-omero github.com/hadim/docker-omero
```

Run the container :

```
docker run -p 4064:4064 -p 4063:4063 -p 8080:80 -t hadim/docker-omero
```

You should be able to connect with OMEROinsight client or via webserver at http://localhost:8080. Default password for user `root` is `password`.

If you run the container without volume binding, all omero data will reside in the docker container. To avoid that, first create a `data` folder on host system and then bind it within the container :

```
docker run -p 4064:4064 -p 4063:4063 -p 8080:80 --name omero -v ~/data:/data -t hadim/docker-omero
```

Automatic backup of database is made every day via cron. Backups are stored to `/data/backups`. To launch a manual backup, use :

```
# omero is the name of the running container
dòcker exec -ti omero /etc/cron.daily/backup-omero-database.sh
```

You can also restore a backup (note that the path is relative to the container) :

```
docker run -p 4064:4064 -p 4063:4063 -p 8080:80 --name omero -v ~/data:/data -t hadim/docker-omero --restore /data/backups/2014_11_18_09_35_omero_db.tar.bz2
```

Or ask to restore the last found backup in `/data/backups`:

```
docker run -p 4064:4064 -p 4063:4063 -p 8080:80 --name omero -v ~/data:/data -t hadim/docker-omero --restore-last
```

## TODO

- add a system to use external database
