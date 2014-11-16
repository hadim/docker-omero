# docker-omero

Docker file to build omero server. Largely inspired form http://www.openmicroscopy.org/site/support/omero5/sysadmins/unix/server-linux-walkthrough.html.

## Install

You can pull or build the docker images :

```
docker pull hadim/docker-omero
# or
docker build -t hadim/docker-omero github.com/hadim/docker-omero
```

Now run the container :

```
docker run -p 4064:4064 -p 4063:4063 -p 8080:80 -t hadim/docker-omero
```

Now you should be able to connect with OMEROinsight or with http://localhost:8080 (not working for now). For OMEROinsight, default password for user `root` is `omero_root_password`.

Note that `data`, `/home/omero/OMERO.server/var`, `/var/log/postgresql`, `/var/lib/postgresql` are declared as docker volume so you can 'mount' them in other containers or bind them with host directory. See https://docs.docker.com/userguide/dockervolumes/ for details.

## TODO

- make webserver work
- make Postgresql installation optional and use an already configured database instance
