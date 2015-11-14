.PHONY: runserver runwebdev shellweb

runserver:
	docker-compose run --rm omero-server

runweb:
	docker-compose run --rm --name omero-web omero-web

runwebdev:
	docker-compose run --rm --name omero-web omero-web bash

shellserver:
	docker exec -ti omero-server bash

shellweb:
	docker exec -ti omero-web bash
