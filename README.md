# docker-aria2 [![Docker Pulls](https://img.shields.io/docker/pulls/hobbsau/aria2.svg)](https://hub.docker.com/r/hobbsau/aria2/)

Run aria2c from a docker container

## Install
```sh
docker pull hobbsau/aria2
```

## Usage

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
