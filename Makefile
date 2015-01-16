init:
	docker run --name data omero-data true
	docker run --volumes-from data --rm=true -e PGDATA=/data/postgres omero-postgres sh init.sh
	docker run -d --name pg --volumes-from data -e PGDATA=/data/postgres omero-postgres
	docker run --link pg:pg --volumes-from data -ti --rm=true -p 4064:4064 omero sh init.sh

start:
	docker stop pg ; docker rm pg ; \
	docker run -d --name pg --volumes-from data -e PGDATA=/data/postgres omero-postgres
	docker run -d --name omero --link pg:pg --volumes-from data -p 4064:4064 omero

# Stop instances except data
stop:
	docker stop pg
	docker rm pg
	docker stop omero
	docker rm omero

# Build images
build: mkdata mkpostgres mkomero

mkdata:
	docker build -t omero-data omero-data

mkpostgres:
	docker build -t omero-postgres omero-postgres

mkomero:
	docker build -t omero omero

# Get shell
datash:
	docker run -ti --volumes-from data --rm=true omero-data sh

pgsh:
	docker exec -ti pg bash

omerosh:
	docker exec -ti omero bash


