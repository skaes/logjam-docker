FROM ubuntu:noble
LABEL maintainer="Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

# ----------------------------
# Environment (can be used in scripts)
# ----------------------------
ENV HOME=/root
WORKDIR /root

# ----------------------------
# Add railsepxess package source
# ----------------------------
RUN apt-get update -y && apt-get install apt-transport-https ca-certificates -y && \
    echo 'deb [trusted=yes] https://railsexpress.de/packages/ubuntu/noble ./' >> /etc/apt/sources.list

# ----------------------------
# update system
# ----------------------------
RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8; \
    apt-get install -y \
        autoconf \
        automake \
        bison \
        build-essential \
        checkinstall \
        ca-certificates \
        cmake \
        curl \
        dpkg-dev \
        gawk \
        git \
        git-core \
        htop \
        libcurl4-openssl-dev \
        libffi-dev \
        libgdbm-dev \
        libgmp-dev \
        libicu-dev \
        libncurses5-dev\
        libreadline-dev \
        libsqlite3-dev\
        libssl-dev \
        libtool \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        lsof \
        nodejs \
        patch \
        pkg-config \
        sudo \
        wget \
        zlib1g-dev
