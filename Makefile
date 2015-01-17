# Init data container
initdata:
	docker run --name data omero-data true

# Start containers
start: runpg runomeroserver runomeroweb

runpg:
	docker run -d --name pg --volumes-from data -e PGDATA=/data/postgres omero-postgres

runomeroserver:
	docker run -d --name omero-server --link pg:pg --volumes-from data -p 4064:4064 omero-server

runomeroweb:
	docker run -d --name omero-web --link omero-server:omero_server --volumes-from data -p 80:80 omero-web

stop:
	docker stop omero-server
	docker rm omero-server
	docker stop pg
	docker rm pg
	docker stop omero-web
	docker rm omero-web

# Build images
build: mkdata mkpostgres mkomero-server mkomero-web

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
	docker run -ti --volumes-from data --rm=true omero-data sh

pgsh:
	docker exec -ti pg bash

omerosh:
	docker exec -ti omero-server bash


