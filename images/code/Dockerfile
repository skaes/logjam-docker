# VERSION         0.1
# DOCKER-VERSION  1.10.2
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam code builder
#
# TO_BUILD:            docker build -t=stkaes/logjam-code .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/logjam-code /bin/bash
# ----------------------------
FROM stkaes/logjam-ruby
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y --no-install-recommends install nodejs tzdata && apt-get clean

ENV LOGJAM_REVISION 8b5bde8250508a78a929668c39015d9f60bd18dd



ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./install-code.sh /docker/install-code.sh
RUN /bin/bash -l -c /docker/install-code.sh

WORKDIR /opt/logjam/app

# restore DEBIAN_FRONTEND to default value
ENV DEBIAN_FRONTEND newt
