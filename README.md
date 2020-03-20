# logjam-docker

A collection of docker files and support scripts to build and run a
dockerized instance of logjam_app. Also builds Ubuntu packages.

# Running dockerized logjam

Assuming you have `docker` and `docker-compose` installed on your
system you can run the app with a single command (after downloading
`docker-compose.yml` and `logjam.env`):

````bash
docker-compose up -d
# ...
docker-compose stop
````

You will need to create a data directory `~/data` beforehand though.

## Notes

* you might want to change the `TZ` setting in `logjam.env`
* if you're running on OS X and port forwarding doesn't work for you
  anymore, open the virtual box manager and add port forwarding rules
  for ports 80, 8080, and 9605.

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
the fly.
