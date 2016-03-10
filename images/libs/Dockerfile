# VERSION         0.1
# DOCKER-VERSION  1.10.2
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam-tools builder
#
# TO_BUILD:            docker build -t=stkaes/libs .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/libs /bin/bash
# ----------------------------
FROM stkaes/logjam-builder
MAINTAINER Stefan Kaes <skaes@railsexpress.de>
ENV DEBIAN_FRONTEND noninteractive

ENV LOGJAM_LIBS_REVISION 540d4e6be1aecccb60d274606b34d28247f0bf85

ADD ./install-logjam-libs.sh /docker/install-logjam-libs.sh
RUN /bin/bash -l -c /docker/install-logjam-libs.sh

# restore DEBIAN_FRONTEND to default value
ENV DEBIAN_FRONTEND newt
