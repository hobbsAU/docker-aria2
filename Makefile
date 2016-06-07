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
	echo "Rebuilding container..."; \
	@curl --data build=true -X POST $(TRIGGER_URL) 

# Intantiate service continer and start it
run: 
	@if [ -z "`docker ps -a -q -f name=$(CONTAINER_RUN)`" ]; \
	then \
		docker pull $(CONTAINER_REPO); \
		echo "Creating and starting container..."; \
		docker run -d \
 		--restart=always \
 		-p 6800:6800/tcp \
 		-v $(CONFIG_BIND)$(CONFIG_VOL) \
 		-v $(DATA_BIND_1)$(DATA_VOL_1) \
 		-v $(DATA_BIND_2)$(DATA_VOL_2) \
 		--name $(CONTAINER_RUN) \
 		$(CONTAINER_REPO); \
	else \
		echo "$(CONTAINER_RUN) is already running or a stopped container by the same name exists!"; \
		echo "Please try \'make clean\' and then \'make run\'"; \
	fi

# Start the service container. 
start:
	@if [ -z "`docker ps -q -f name=$(CONTAINER_RUN)`" ] && [ -n "`docker ps -a -q -f name=$(CONTAINER_RUN)`" ]; \
        then \
		echo "Starting container..."; \
		docker start $(CONTAINER_RUN); \
	else \
		echo "Container $(CONTAINER_RUN) doesn't exist or is not in a stopped state!"; \
	fi

# Stop the service container. 
stop:
	@if [ -z "`docker ps -q -f name=$(CONTAINER_RUN)`" ]; \
        then \
		echo "Nothing to stop as container $(CONTAINER_RUN) isn't running!"; \
	else \
		echo "Stopping container..."; \
		docker stop $(CONTAINER_RUN); \
	fi

# Service container is ephemeral so clean should be used with impunity.
clean: stop
	@if [ -z "`docker ps -a -q -f name=$(CONTAINER_RUN)`" ]; \
        then \
		echo "Nothing to remove as container $(CONTAINER_RUN) doesn't exist!"; \
	else \
		echo "Removing container..."; \
		docker rm $(CONTAINER_RUN); \
	fi

upgrade: clean build run
