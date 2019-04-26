FROM stkaes/logjam-ruby
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y --no-install-recommends install nodejs tzdata && apt-get clean

ENV LOGJAM_REVISION 2020824c3c812bc5adb8138e8d17ae81cc0cdee8



ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./install-code.sh /docker/install-code.sh
RUN /bin/bash -l -c /docker/install-code.sh

WORKDIR /opt/logjam/app
