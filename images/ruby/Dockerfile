# VERSION         0.1
# DOCKER-VERSION  1.10.2
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam-ruby builder
#
# TO_BUILD:            docker build -t=stkaes/ruby .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/ruby /bin/bash
# ----------------------------
FROM stkaes/logjam-builder
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y --no-install-recommends ruby
ADD ./install-ruby.sh /docker/install-ruby.sh
RUN /bin/bash -l -c '/docker/install-ruby.sh ruby-2.4.2-p198'
ADD ./gemrc /opt/logjam/etc/gemrc

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN gem update -q --system
RUN gem install -q bundler

# restore DEBIAN_FRONTEND to default value
ENV DEBIAN_FRONTEND newt
