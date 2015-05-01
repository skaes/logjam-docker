# VERSION         0.1
# DOCKER-VERSION  1.6.0
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>, Jochen Kramer <freetwix@web.de>
# DESCRIPTION:    logjam demo
#
# TO_BUILD:            docker build -t=stkaes/logjamdemo .
# TO_RUN_INTERACTIVE:  docker run --rm -i -t -p 3000:3000 -p 8080:8080 stkaes/logjamdemo
# ----------------------------
FROM stkaes/logjam-builder
MAINTAINER Stefan Kaes

ADD ./opt-logjam-tools.tar.gz /
ADD ./opt-logjam-ruby.tar.gz /
ADD ./opt-logjam-app.tar.gz /
ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# ----------------------------
# data stores
# ----------------------------
RUN apt-get -y --no-install-recommends install mongodb memcached && apt-get clean

# ----------------------------
# logjam
# ----------------------------
RUN apt-get install -y runit && apt-get clean
ADD ./install-services.sh /docker/install-services.sh
RUN /bin/bash -l -c /docker/install-services.sh

WORKDIR /opt/logjam/app
ADD ./startapp.sh /docker/startapp.sh
CMD /docker/startapp.sh

EXPOSE 3000 8080
