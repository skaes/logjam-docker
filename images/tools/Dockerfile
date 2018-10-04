# VERSION         0.1
# DOCKER-VERSION  1.10.2
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam-tools builder
#
# TO_BUILD:            docker build -t=stkaes/tools .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/tools /bin/bash
# ----------------------------
FROM stkaes/logjam-libs
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

ENV LOGJAM_TOOLS_REVISION 32470571f7845044f5281dc0de02fde3defa10ad

ADD ./install-logjam-tools.sh /docker/install-logjam-tools.sh
RUN /bin/bash -l -c /docker/install-logjam-tools.sh
