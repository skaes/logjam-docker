# VERSION         0.1
# DOCKER-VERSION  1.6.0
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam demo
#
# TO_BUILD:            docker build -t=stkaes/logjam-demo .
# TO_RUN_INTERACTIVE:  docker run --rm -i -t -p 80:80 -p 8080:8080 stkaes/logjam-demo
# ----------------------------
FROM stkaes/logjam-app
MAINTAINER Stefan Kaes <skaes@railsexpress.de>

ENV LOGJAM_PRODUCTION_DB localhost

RUN apt-get -y --no-install-recommends install mongodb && apt-get clean
ADD ./service/mongodb /etc/service/mongodb
