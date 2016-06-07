#Makefile for Docker container control

# Include additional variables
include /srv/aria2/a.mk

# Define container repo and runtime name
CONTAINER_REPO = hobbsau/aria2
CONTAINER_RUN = aria2-service

# Define the exportable volumes for the container
CONFIG_VOL = /home/aria2

# This should point to the Docker host directory containing the config. The host directory must be owned by UID:GID 1000:1000. The format is '/host/directory:'
CONFIG_BIND = /srv/aria2:

# URL for triggering a rebuild
TRIGGER_URL = https://registry.hub.docker.com/u/hobbsau/aria2/trigger/26f5ecc6-8887-4f45-ba8a-c7d0fb9b27c1/

# Trigger a remote initiated rebuild
build:
	echo "Rebuilding container..."; \
	@curl --data build=true -X POST $(TRIGGER_URL) 

# Intantiate service continer and start it
run: 
	@if [ -z "`docker ps -a -q -f name=$(CONTAINER_RUN)`" ]; \
	then \
		echo "Checking for latest container..."; \
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
		echo "Please try 'make clean' and then 'make run'"; \
	fi

# Start the service container. 
start:
	@if [ -z "`docker ps -q -f name=$(CONTAINER_RUN)`" ] && [ -n "`docker ps -a -q -f name=$(CONTAINER_RUN)`" ]; \
        then \
		echo "Starting container..."; \
		docker start $(CONTAINER_RUN); \
	else \
		echo "Container $(CONTAINER_RUN) doesn't exist or is already running!"; \
	fi

# Stop the service container. 
stop:
	@if [ -z "`docker ps -q -f name=$(CONTAINER_RUN)`" ]; \
        then \
		echo "Nothing to stop as container $(CONTAINER_RUN) is not running!"; \
	else \
		echo "Stopping container..."; \
		docker stop $(CONTAINER_RUN); \
	fi

# Service container is ephemeral so clean should be used with impunity.
clean: stop
	@if [ -z "`docker ps -a -q -f name=$(CONTAINER_RUN)`" ]; \
        then \
		echo "Nothing to remove as container $(CONTAINER_RUN) does not exist!"; \
	else \
		echo "Removing container..."; \
		docker rm $(CONTAINER_RUN); \
	fi

# Upgrade the container - may not work if rebuild takes too long
upgrade: build clean run
