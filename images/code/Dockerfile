# VERSION         0.1
# DOCKER-VERSION  1.10.2
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam code builder
#
# TO_BUILD:            docker build -t=stkaes/logjam-code .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/logjam-code /bin/bash
# ----------------------------
FROM stkaes/logjam-ruby
MAINTAINER Stefan Kaes <skaes@railsexpress.de>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y --no-install-recommends install nodejs && apt-get clean

ENV LOGJAM_REVISION f7ce13da9d04fec34806c1dd03a463ddd40f5bdb



ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./install-code.sh /docker/install-code.sh
RUN /bin/bash -l -c /docker/install-code.sh

WORKDIR /opt/logjam/app

# restore DEBIAN_FRONTEND to default value
ENV DEBIAN_FRONTEND newt
