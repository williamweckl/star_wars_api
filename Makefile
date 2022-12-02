
.DEFAULT_GOAL := help

ifeq (, $(shell which docker))
	$(error "docker is not installed, installation instructions in https://docs.docker.com/engine/installation/")
endif

ifeq (, $(shell which docker-compose))
	$(error "docker-compose is not installed, installation instructions in https://docs.docker.com/compose/install/")
endif

help:			## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

docker.app.start:	## Start APP containers.
	docker-compose run -p 4000:4000 --rm api --name api

docker.app.stop:	## Stop APP containers.
	docker-compose stop

docker.app.logs:	## Show logs from APP containers. Use opts=args for more options of docker-compose logs
	docker-compose logs

docker.code.lint:	## Run linter inside docker container.
	CONTAINER_ID=$$(docker ps -f name=api -q) && docker exec -it $$CONTAINER_ID mix credo

docker.services.start:	## Start services containers.
	docker-compose -f docker-compose-services.yml -p star_wars up -d --remove-orphans

docker.services.stop:	## Stop services containers
	docker-compose -f docker-compose-services.yml -p star_wars stop

docker.services.logs:	## Show logs from services containers. Use opts=args for more options of docker-compose logs
	docker-compose -f docker-compose-services.yml -p star_wars logs
