# VERSION         0.1
# DOCKER-VERSION  1.7.1
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam code builder
#
# TO_BUILD:            docker build -t=stkaes/logjam-code .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/logjam-code /bin/bash
# ----------------------------
FROM stkaes/logjam-ruby
MAINTAINER Stefan Kaes <skaes@railsexpress.de>
ENV DEBIAN_FRONTEND noninteractive

ENV LOGJAM_REVISION d484ec872add85b109cb5b4564cbe0cbad87b9da

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./install-code.sh /docker/install-code.sh
RUN /bin/bash -l -c /docker/install-code.sh

WORKDIR /opt/logjam/app

# restore DEBIAN_FRONTEND to default value
ENV DEBIAN_FRONTEND newt
