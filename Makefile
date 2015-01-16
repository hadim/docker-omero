BACKUP_NAME := $(date +"%Y_%m_%d_%H_%M_omero.tar.bz2")

init:
	docker run --name data omero-data true
	docker run --volumes-from data --rm=true -e PGDATA=/data/postgres omero-postgres sh init.sh

startpg:
	docker run -d --name pg --volumes-from data -e PGDATA=/data/postgres omero-postgres

initomero:
	docker run --link pg:pg --volumes-from data -ti --rm=true -p 4064:4064 omero sh init.sh

startomero:
	docker run -d --name omero --link pg:pg --volumes-from data -p 4064:4064 omero

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

# Stop instances
stop:
	docker stop pg
	docker rm pg
	docker stop omero
	docker rm omero
