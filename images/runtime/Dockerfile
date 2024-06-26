FROM ubuntu:jammy
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"

# ----------------------------
# Environment (can be used in scripts)
# ----------------------------
ENV HOME /root
WORKDIR /root

# ----------------------------
# allow packages from the logjam package cloud repo
# ----------------------------
# RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y apt-transport-https curl gnupg locales locales-all tzdata
# if we don't install curl, https transport for apt won't work
# ADD packagecloud.gpg.key /etc/apt/packagecloud.gpg.key
# RUN apt-key add /etc/apt/packagecloud.gpg.key
# ADD stkaes_logjam.list /etc/apt/sources.list.d/stkaes_logjam.list
# RUN apt-get update -y
# alternative which requires a bit more trust
# RUN apt-get install -y curl && (curl -s https://packagecloud.io/install/repositories/stkaes/logjam/script.deb.sh | bash)

# ----------------------------
# runtime packages
# ----------------------------
ENV LOGJAM_TOOLS_REVISION 7d8a9c09e3c8196dff6c96c587f34ac1c7cfb731

RUN apt-get update -y && apt-get install apt-transport-https ca-certificates -y && \
    echo 'deb [trusted=yes] https://railsexpress.de/packages/ubuntu/jammy ./' >> /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        cron \
        gawk \
        htop \
        less \
        libcurl4 \
        libffi7 \
        libgdbm6 \
        libgmp10 \
        libicu70 \
        libncurses5 \
        libreadline8 \
        libsqlite3-0 \
        libssl3 \
        libxml2 \
        libxslt1.1 \
        libyaml-0-2 \
        locales \
        locales-all \
        lsof \
        net-tools \
        nodejs \
        runit \
        sudo  \
        tzdata \
        wget \
        zlib1g \
        logjam-libs \
        logjam-tools \
        logjam-passenger \
    && rm -rf /var/lib/apt/lists/* && rm /etc/service

# ----------------------------
# set locale
# ----------------------------
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8
