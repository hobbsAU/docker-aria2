#Makefile for Docker container control

#include additional variables
include /srv/aria2/a.mk

# define docker container
CONTAINER_REPO = hobbsau/aria2
CONTAINER_RUN = aria2-service

# define the exportable volumes for the data container
CONFIG_VOL = /home/aria2

# This should point to the host directory containing the config. The host directory must be owned by UID:GID 1000:1000. The format is /host/directory:
CONFIG_BIND = /srv/aria2:

TRIGGER_URL = https://registry.hub.docker.com/u/hobbsau/aria2/trigger/26f5ecc6-8887-4f45-ba8a-c7d0fb9b27c1/

build:
	@curl --data build=true -X POST $(TRIGGER_URL) 


run: 
	@if [ -z "`docker ps -q -f name=$(CONTAINER_RUN)`" ]; \
	then \
		docker pull $(CONTAINER_REPO); \
		docker run -d \
 		--restart=always \
 		-v $(CONFIG_BIND)$(CONFIG_VOL) \
 		-v $(DATA_BIND_1)$(DATA_VOL_1) \
 		-v $(DATA_BIND_2)$(DATA_VOL_2) \
 		--name $(CONTAINER_RUN) \
 		$(CONTAINER_REPO); \
	else \
		echo "$(CONTAINER_RUN) already running!"; \
	fi

# Service container is ephemeral so let's delete on stop. Data container is persistent so we do not touch
stop:
	@if [ -z "`docker ps -q -f name=$(CONTAINER_RUN)`" ]; \
        then \
		echo "Nothing to stop as container $(CONTAINER_RUN) isn't running!"; \
	else \
	docker stop $(CONTAINER_RUN); \
	docker rm $(CONTAINER_RUN); \
	fi

clean: stop
	@if [ -z "`docker ps -a -q -f name=$(CONTAINER_RUN)`" ]; \
        then \
		echo "Nothing to remove as container $(CONTAINER_RUN) doesn't exist!"; \
	else \
	echo "Removing container..."; \
	docker rm $(CONTAINER_RUN); \
	fi

upgrade: clean build run
