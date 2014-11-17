# docker-omero

Docker file to build omero server. Largely inspired form http://www.openmicroscopy.org/site/support/omero5/sysadmins/unix/server-linux-walkthrough.html.

## Install

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

You should be able to connect with OMEROinsight client or via webserver at http://localhost:8080. Default password for user `root` is `omero_root_password`.

If you run the container without volume binding, all omero data will reside in the docker container. To avoid that, first create a `data` folder on host system and then bind it within the container :

```
docker run -p 4064:4064 -p 4063:4063 -p 8080:80 --name omero -v ~/data:/data  -ti hadim/docker-omero
```

## TODO

- build efficient and smart backup and restore system
- make Postgresql installation optional and use an already configured database instance
- use a Postgresql container for database ?
- find the best way to handle logs (read and write)
