FROM stkaes/logjam-builder
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y --no-install-recommends ruby
ADD ./install-ruby.sh /docker/install-ruby.sh
RUN /bin/bash -l -c '/docker/install-ruby.sh ruby-2.6.3-p62'
ADD ./gemrc /opt/logjam/etc/gemrc

ADD ./install-bundler.sh /docker/install-bundler.sh
RUN /docker/install-bundler.sh

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN gem update -q --system 3.0.3
