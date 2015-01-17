init:
	docker run --name data omero-data true
	docker run --volumes-from data --rm=true -e PGDATA=/data/postgres omero-postgres sh init.sh
	docker run -d --name pg --volumes-from data -e PGDATA=/data/postgres omero-postgres
	docker run --link pg:pg --volumes-from data -ti --rm=true -p 4064:4064 omero-server sh init.sh

start:
	docker stop pg ; docker rm pg ; \
	docker run -d --name pg --volumes-from data -e PGDATA=/data/postgres omero-postgres
	docker run -d --name omero-server --link pg:pg --volumes-from data -p 4064:4064 omero-server
	docker run -d --name omero-web --link omero-server:omero_server -p 80:80 omero-web

# Stop instances except data
stop:
	docker stop pg
	docker rm pg
	docker stop omero-server
	docker rm omero-server
	docker stop omero-web
	docker rm omero-web

# Build images
build: mkomero-base mkdata mkpostgres mkomero-server mkomero-web

mkomero-base:
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
	docker run -ti --volumes-from data --rm=true omero-data sh

pgsh:
	docker exec -ti pg bash

omerosh:
	docker exec -ti omero-server bash


