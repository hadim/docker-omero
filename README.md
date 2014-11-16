# docker-omero

Docker file to build omero server. Largely inspired form http://www.openmicroscopy.org/site/support/omero5/sysadmins/unix/server-linux-walkthrough.html.

## Install

You can pull or build the docker images :

```
docker pull hadim/docker-omero
```

or

```
docker build -t hadim/docker-omero github.com/hadim/docker-omero
```

Now run the container :

```
docker run -p 4064:4064 -p 8080:80 -t hadim/docker-omero
```

Now you should be able to connect with OMEROinsight or with http://localhost:8080 (not working for now).

For OMEROinsight, use localhost and 4064. Default password for user `root` is `omero_root_password`.

## TODO

- make webserver work
- make Postgresql installation optional and use an already configured database instance
