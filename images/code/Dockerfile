ARG TARGETARCH
FROM stkaes/logjam-builder:latest-${TARGETARCH}
LABEL maintainer="Stefan Kaes <skaes@railsexpress.de>"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get -y --no-install-recommends install \
        logjam-ruby=3.3.5* \
        nodejs \
        tzdata \
        && apt-get clean

ENV LOGJAM_REVISION=a43a30fed888204d7c2bbab095b2eb040939d22c

ENV PATH=/opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./install-code.sh /docker/install-code.sh
RUN /bin/bash -l -c /docker/install-code.sh

WORKDIR /opt/logjam/app
