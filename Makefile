.PHONY: runserver runweb runwebdev shellserver shellweb

runserver:
	docker-compose run --rm omero-server

runweb:
	OMERO_WEB_DEVELOPMENT=no docker-compose run --rm --name omero-web -p 80:80 -p 443:443 omero-web

runwebdev:
	OMERO_WEB_DEVELOPMENT=yes docker-compose run --rm --name omero-web -p 4080:4080 omero-web bash -l

shellserver:
	docker exec -ti omero-server bash -l

shellweb:
	docker exec -ti omero-web bash -l
