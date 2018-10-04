# VERSION         0.1
# DOCKER-VERSION  1.10.2
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam-ruby builder
#
# TO_BUILD:            docker build -t=stkaes/passenger .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/passenger /bin/bash
# ----------------------------
FROM stkaes/logjam-ruby
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN gem install passenger -v 5.2.2
RUN passenger start --runtime-check-only
# This will compile passenger native support in the backgound
RUN passenger start -d ; sleep 5

CMD passenger start

EXPOSE 80
