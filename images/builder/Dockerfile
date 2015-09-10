# VERSION         0.1
# DOCKER-VERSION  1.7.1
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam base builder package
#
# TO_BUILD:            docker build -t=stkaes/builder .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/builder
# ----------------------------
FROM ubuntu:14.04
MAINTAINER Stefan Kaes <skaes@railsexpress.de>
ENV DEBIAN_FRONTEND noninteractive

# ----------------------------
# Environment (can be used in scripts)
# ----------------------------
ENV HOME /root
WORKDIR /root

# ----------------------------
# update system
# ----------------------------
RUN apt-get update; apt-get -y upgrade
RUN locale-gen en_US.UTF-8 && \
  update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# ----------------------------
# development packages
# ----------------------------
RUN apt-get install -y \
    autoconf \
    automake \
    bison \
    build-essential \
    checkinstall \
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
    patch \
    pkg-config \
    sudo \
    wget \
    zlib1g-dev

# restore DEBIAN_FRONTEND to default value
ENV DEBIAN_FRONTEND newt
