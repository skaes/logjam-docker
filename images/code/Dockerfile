FROM stkaes/logjam-ruby
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y --no-install-recommends install nodejs tzdata && apt-get clean

ENV LOGJAM_REVISION ddbf22080a15b5969f29a6e65c9bc08acc6f4c3c



ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./install-code.sh /docker/install-code.sh
RUN /bin/bash -l -c /docker/install-code.sh

WORKDIR /opt/logjam/app
