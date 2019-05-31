FROM stkaes/logjam-libs
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

ENV LOGJAM_TOOLS_REVISION 34784fb8bb486c54098016c197b987bf5753edf7

ADD ./install-logjam-tools.sh /docker/install-logjam-tools.sh
RUN /bin/bash -l -c /docker/install-logjam-tools.sh
