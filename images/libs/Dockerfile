# VERSION         0.1
# DOCKER-VERSION  1.7.1
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam-tools builder
#
# TO_BUILD:            docker build -t=stkaes/libs .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/libs /bin/bash
# ----------------------------
FROM stkaes/logjam-builder
MAINTAINER Stefan Kaes <skaes@railsexpress.de>

ENV LOGJAM_TOOLS_REVISION 81e3bfb99a4e066c51fad14485dc2fa9ee45a0ac

ADD ./install-logjam-libs.sh /docker/install-logjam-libs.sh
RUN /bin/bash -l -c /docker/install-logjam-libs.sh
