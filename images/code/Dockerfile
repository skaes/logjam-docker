ARG TARGETARCH
FROM stkaes/logjam-builder:latest-${TARGETARCH}
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get -y --no-install-recommends install \
        logjam-ruby \
        nodejs \
        tzdata \
        && apt-get clean

ENV LOGJAM_REVISION 034d701486d4654bd1a09e58e91fee95063ea198

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./install-code.sh /docker/install-code.sh
RUN /bin/bash -l -c /docker/install-code.sh

WORKDIR /opt/logjam/app
