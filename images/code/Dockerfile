ARG TARGETARCH
FROM stkaes/logjam-builder:latest-${TARGETARCH}
LABEL maintainer="Stefan Kaes <skaes@railsexpress.de>"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get -y --no-install-recommends install \
        logjam-ruby=3.3.1* \
        nodejs \
        tzdata \
        && apt-get clean

ENV LOGJAM_REVISION=4d7865d8bd12ca938e4def403ce5751a3430b0ce

ENV PATH=/opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./install-code.sh /docker/install-code.sh
RUN /bin/bash -l -c /docker/install-code.sh

WORKDIR /opt/logjam/app
