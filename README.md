# docker-aria2 [![Docker Pulls](https://img.shields.io/docker/pulls/hobbsau/aria2.svg)](https://hub.docker.com/r/hobbsau/aria2/)

Run aria2c from a docker container

Key features of this repository:
* Efficiency - image is small <10MB
* Security - process runs inside the container as regular user and so does the docker image with the USER directive
* Management - make script allows for easy configuration and ongoing maintenance

## Prerequisites
To use this package you must ensure the following:
* Linux host system configured with a working Docker installation 
* make installed (optional for management script)
* git installed (optional for src and management script)


## Installation - including management scripts and src
```sh
        git clone https://github.com/hobbsAU/docker-aria2.git
        cd docker-aria2
        make run
```

## Installation - standalone Docker image
```sh
docker pull hobbsau/aria2
```

## Usage - using management scripts

### Creating and running the container
```sh
$ make run
```

### Stopping a running container
```sh
$ make stop
```

### Starting a stopped container
```sh
$ make start
```

### Destroying (deleting) a running or stopped container
```sh
$ make clean
```

### Remotely trigger a container rebuild
```sh
$ make build
```


## Usage - standalone Docker image

First let's setup the data container that will map the config directory from the host to the container as well as the output directory. This container will provide persistent storage.
```sh
$ docker create \
 --name aria2-data \
 -v <hostdir>:/config \
 -v <hostdir>:/mnt \
 hobbsau/aria2 \
 /bin/true
```  

Example using my host and the /srv/aria2 location on my host:
```sh
$ sudo docker create --name aria2-data -v /srv/aria2/config:/config -v /srv/aria2/mnt:/mnt hobbsau/aria2
```  

Next we run the aria2-service and this will automatically map the volumes within the new container.
```sh
$ docker run -d \
 --restart=always \
 --volumes-from aria2-data \
 --name aria2-service \
 hobbsau/aria2
```  

You should see two new containers in the docker listing:
```sh
$ docker ps -a
```

## Developing
The [source repo](https://github.com/hobbsAU/docker-aria2) is linked to dockerhub using autobuild. Any push to this repo will auto-update the docker image on docker hub.
