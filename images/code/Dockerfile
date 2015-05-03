# VERSION         0.1
# DOCKER-VERSION  1.6.0
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam code builder
#
# TO_BUILD:            docker build -t=stkaes/logjam-code .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/logjam-code /bin/bash
# ----------------------------
FROM stkaes/logjam-ruby
MAINTAINER Stefan Kaes <skaes@railsexpress.de>

ENV LOGJAM_REVISION 7922051f8ce23edab081b7685e3513065b3816a7

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./install-code.sh /docker/install-code.sh
RUN /bin/bash -l -c /docker/install-code.sh

WORKDIR /opt/logjam/app
