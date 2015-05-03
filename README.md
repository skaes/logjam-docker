# logjam-docker

A collection of docker files and support scripts to build and run a
dockerized instance of logjam_app

# Running Dockerized Logjam

Assuming you have docker installed on your system, there are two
options, the advantages/disvantages of which are left as an exercise
for the docker aficionado:

## Running an All In One Container

````bash
docker run -d -p 80:80 -p 8080:8080 --name demo stkaes/logjam-demo
````

## Running a Separate Mongodb Container

## With Standard Ports
````bash
docker run -d -P --name logjamdb mongo
docker run -d -p 80:80 -p 8080:8080 --link logjamdb:logjamdb --name logjam stkaes/logjam-app
````

## Customization

In order to add new applications to be monitored by logjam, you will
need to write a new Dockerfile and mount a modified initializer file
for logjam streams on top.
