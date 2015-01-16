init:
	docker run --name data omero-data true
	docker run --volumes-from data -e PGDATA=/data/postgres omero-postgres sh /init.sh
	#docker run --link pg:pg --volumes-from data omero sh /init.sh

mkdata:
	docker build -t omero-data omero-data

mkpostgres:
	docker build -t omero-postgres omero-postgres

mkomero:
	docker build -t omero omero

datash:
	docker run -ti --volumes-from data omero-data sh

pgsh:
	docker run -ti --volumes-from data omero-postgres bash

clean:
	docker rm -f data
	docker rm -f omero
	docker rm -f pg
