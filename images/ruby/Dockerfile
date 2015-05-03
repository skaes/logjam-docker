# VERSION         0.1
# DOCKER-VERSION  1.6.0
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam-ruby builder
#
# TO_BUILD:            docker build -t=stkaes/ruby .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/ruby /bin/bash
# ----------------------------
FROM stkaes/logjam-builder
MAINTAINER Stefan Kaes <skaes@railsexpress.de>

RUN apt-get install -y --no-install-recommends ruby
ADD ./install-ruby.sh /docker/install-ruby.sh
RUN /bin/bash -l -c '/docker/install-ruby.sh ruby-2.2.2-p95'
ADD ./gemrc /opt/logjam/etc/gemrc

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN gem update -q --system
RUN gem install -q bundler
