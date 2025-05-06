ARG TARGETARCH
FROM stkaes/logjam-builder:latest-${TARGETARCH}
LABEL maintainer="Stefan Kaes <skaes@railsexpress.de>"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get -y --no-install-recommends install \
        logjam-ruby=3.3.5* \
        nodejs \
        tzdata \
        && apt-get clean

ENV LOGJAM_REVISION=be10e61eec5666ff61d7320935ae6f3d7112b98c

ENV PATH=/opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./install-code.sh /docker/install-code.sh
RUN /bin/bash -l -c /docker/install-code.sh

WORKDIR /opt/logjam/app
