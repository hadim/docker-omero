.PHONY: initdata initdatahost runpg runomeroserver runomeroweb stop rm

OMERO_WEB_PORT=8080
OMERO_WEB_PORT_SSL=443
OMERO_SERVER_PORT=4064
OMERO_DATA_DIR=~/data

# Init data container
initdata:
	docker run --name omero-data omero-data true

# Init data container with volume on host
initdatahost:
	mkdir -p $(OMERO_DATA_DIR)
	chmod 777 $(OMERO_DATA_DIR)
	docker run --name omero-data --privileged=true -v $(OMERO_DATA_DIR):/data:Z omero-data true

# Start containers
start: build runpg runomeroserver runomeroweb

runpg:
	docker run -d --name omero-pg --volumes-from omero-data -e PGDATA=/data/postgres omero-postgres

runomeroserver:
	docker run -d --name omero-server --link omero-pg:omero-pg --volumes-from omero-data -p $(OMERO_SERVER_PORT):4064 omero-server

runomeroweb:
	docker run -d --name omero-web --volumes-from omero-data --link omero-server:omero_server -p $(OMERO_WEB_PORT):80 -p $(OMERO_WEB_PORT_SSL):443 omero-web

stop:
	docker stop omero-server
	docker stop omero-pg
	docker stop omero-web
	docker stop omero-data

rm:
	docker rm -f omero-server; \
	docker rm -f omero-pg; \
	docker rm -f omero-web; \
	docker rm -f omero-data

# Build images
build: mkbase mkdata mkpostgres mkomero-server mkomero-web

mkbase:
	docker build -t omero-base omero-base

mkdata:
	docker build -t omero-data omero-data

mkpostgres:
	docker build -t omero-postgres omero-postgres

mkomero-server:
	docker build -t omero-server omero-server

mkomero-web:
	docker build -t omero-web omero-web

# Get shell
datash:
	docker run -ti --volumes-from omero-data --rm=true omero-data sh

pgsh:
	docker exec -ti omero-pg bash

omerosh:
	docker exec -ti omero-server bash
