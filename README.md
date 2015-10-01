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

There are currently two ways to add applications to be monitored to logjam.

If you set `LOGJAM_USER_STREAMS` to a comma separated list of stream
names, logjam will process incoming messages from those applications.

````
LOGJAM_USER_STREAMS="gazelles-production,antelopes-production,zebras-production"
````

The second option is to write a custom
[Dockerfile](example/Dockerfile), building on `stkaes/logjam-app` and
adding a custom
[initializer file for logjam streams](example/user_streams.rb) on top
of the existing declarations.

## TODO

At some point in the future, logjam will have a UI to add new apps on
the fly. But for now, this seems OK.
