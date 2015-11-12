cd $OMERO_HOME

if [ $OMERO_WEB_USE_SSL == "yes" ]
then

    # Setup ssl certificates if it is not already here
    if [ ! -f $OMERO_WEB_CERTS_DIR/omero.crt ]; then
        mkdir -p $OMERO_WEB_CERTS_DIR
        cd $OMERO_WEB_CERTS_DIR
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout omero.key -out omero.crt -batch
    fi

fi

./bin/omero config set omero.web.server_list "[[\"$OMERO_SERVER_PORT_4064_TCP_ADDR\", 4064, \"omero\"]]"
./bin/omero web start
