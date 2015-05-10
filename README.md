# logjam-docker

A collection of docker files and support scripts to build and run a
dockerized instance of logjam_app

# Running dockerized logjam

Assuming you have docker installed on your system, there are two
options, the advantages/disvantages of which are left as an exercise
for the docker aficionado:

## Running an all in one container

````bash
docker run -d -p 80:80 -p 8080:8080 --name demo stkaes/logjam-demo
````

## Running with separate mongodb and memcached containers

````bash
docker run -d -P --name logjamdb mongo:3.0.2
docker run -d -P --name memcache memcached:1.4.24
docker run -d -p 80:80 -p 8080:8080 --link logjamdb:logjamdb --link memcache:logjamcache --name logjam stkaes/logjam-app
````

# Customization

In order to add new applications to be monitored by logjam, you will
need to write a new [Dockerfile](example/Dockerfile) building on
stkaes/logjam-app and add a new
[initializer file for logjam streams](example/user_streams.rb) on top
of the existing declarations.

At some point in the future, logjam will have a UI to add new apps
on the fly. But for now, this seems OK.
