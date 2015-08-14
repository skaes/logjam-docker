# logjam-docker

A collection of docker files and support scripts to build and run a
dockerized instance of logjam_app

# Running dockerized logjam

Assuming you have `docker` and `docker-compose` installed on your
system you can run the app with a single command (after downloading
`docker-compose.yml`):

````bash
docker-compose up -d
# ...
docker-compose stop
````

Note: you might want to change the `TZ` setting in `docker-compose.yml`


# Customization

In order to add new applications to be monitored by logjam, you will
need to write a new [Dockerfile](example/Dockerfile) building on
stkaes/logjam-app and add a new
[initializer file for logjam streams](example/user_streams.rb) on top
of the existing declarations.

At some point in the future, logjam will have a UI to add new apps
on the fly. But for now, this seems OK.
