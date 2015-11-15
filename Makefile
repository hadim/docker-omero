.PHONY: runserver runwebdev shellweb

runserver:
	docker-compose run --rm omero-server

runweb:
	OMERO_WEB_DEVELOPMENT=no docker-compose run --rm --name omero-web -p 80:80 -p 443:443 omero-web

runwebdev:
	OMERO_WEB_DEVELOPMENT=yes docker-compose run --rm --name omero-web -p 4080:4080 omero-web bash

shellserver:
	docker exec -ti omero-server bash

shellweb:
	docker exec -ti omero-web bash
