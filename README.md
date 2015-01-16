# docker-omero

Set of Dockerfile to setup an OMERO server. This project aims to be used in production.

## Quick usage

Build images:

```
make build
```

Init data and database containers:

```
make init
```

Start database:

```
make startpg
```

Init OMERO server:

```
make initomero
```

Start OMERO server:

```
make startomero
```

You can now connect to OMERO with the [OMERO Insight client](http://downloads.openmicroscopy.org/latest/omero5). Default admin credentials are root and password. Don't forget to change the password !

If you want to run the server, you can do:

```
make stop
```

To start the server at the same state than when you'll stop it:

```
make startpg startomero
```

If you erase the data container, you'll lost all OMERO data and you have to re do the init process.

To explore the data container you can do:

```
make datash
```

If you want to make a backup you can run:

```
sh backup.sh /some_directory
```

Next you can restore a backup and start a new instance of OMERO server with:

```
sh restore.sh /some_directory/backup_file.tar.bz2
make startpg startomero
```

## TODO

- add web server
- add processor server
- add LDAP server
- import/export custome database/data

## Authors

Hadrien Mary <hadrien.mary@gmail.com>

## License

MIT License. See [LICENSE](LICENSE).
