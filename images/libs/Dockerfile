FROM stkaes/logjam-builder
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

ENV LOGJAM_LIBS_REVISION 34784fb8bb486c54098016c197b987bf5753edf7

ADD ./install-logjam-libs.sh /docker/install-logjam-libs.sh
RUN /bin/bash -l -c /docker/install-logjam-libs.sh
