FROM stkaes/logjam-libs
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

ENV LOGJAM_TOOLS_REVISION 817173b69f487d10cdc9eba37f6e80c797362523

ADD ./install-logjam-tools.sh /docker/install-logjam-tools.sh
RUN /bin/bash -l -c /docker/install-logjam-tools.sh
