# Environment Varibles
CONTAINER = motan-openresty

.PHONY: up

pull :
	docker-compose pull

build :
	docker-compose build

upnew : prep pull
	docker-compose up -d

up :
	docker-compose up -d

down :
	docker-compose down

shell :
	docker exec -ti $(CONTAINER) /bin/bash

tail :
	docker logs -f $(CONTAINER)
