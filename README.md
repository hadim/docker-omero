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

## TODO

- find a trick to bind /data folder (and other folder such as logs and database) to an host folder. `-v /host/data:/data` does not work.
- make Postgresql installation optional and use an already configured database instance
