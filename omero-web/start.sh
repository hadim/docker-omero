cd $OMERO_HOME

./bin/omero config set omero.web.server_list "[[\"$OMERO_SERVER_PORT_4064_TCP_ADDR\", 4064, \"omero\"]]"
./bin/omero web start
