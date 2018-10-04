# VERSION         0.1
# DOCKER-VERSION  1.10.2
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam-tools builder
#
# TO_BUILD:            docker build -t=stkaes/libs .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/libs /bin/bash
# ----------------------------
FROM stkaes/logjam-builder
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

ENV LOGJAM_LIBS_REVISION 32470571f7845044f5281dc0de02fde3defa10ad

ADD ./install-logjam-libs.sh /docker/install-logjam-libs.sh
RUN /bin/bash -l -c /docker/install-logjam-libs.sh
