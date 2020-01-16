FROM stkaes/logjam-libs
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

ENV LOGJAM_TOOLS_REVISION ce355693c888732277fd3edd41ce2ddb1a2ef021

ADD ./install-logjam-tools.sh /docker/install-logjam-tools.sh
RUN /bin/bash -l -c /docker/install-logjam-tools.sh
