# VERSION         0.1
# DOCKER-VERSION  1.6.0
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam-tools builder
#
# TO_BUILD:            docker build -t=stkaes/tools .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/tools /bin/bash
# ----------------------------
FROM stkaes/logjam-builder
MAINTAINER Stefan Kaes <skaes@railsexpress.de>

ENV LOGJAM_TOOLS_REVISION 8b752e9ce6e4cba727f9b75058a14e9c8813d375

ADD ./install-logjam-tools.sh /docker/install-logjam-tools.sh
RUN /bin/bash -l -c /docker/install-logjam-tools.sh
