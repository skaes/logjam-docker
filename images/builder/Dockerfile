# VERSION         0.1
# DOCKER-VERSION  1.6.0
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam base builder package
#
# TO_BUILD:            docker build -t=stkaes/builder .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/builder
# ----------------------------
FROM ubuntu:14.04
MAINTAINER Stefan Kaes

# ----------------------------
# Environment (can be used in scripts)
# ----------------------------
ENV DEBIAN_FRONTEND noninteractive
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
  build-essential autoconf automake libtool pkg-config checkinstall patch \
  sudo lsof curl wget git-core git htop gawk bison \
  zlib1g-dev libyaml-dev libssl-dev libgdbm-dev \
  libreadline-dev libncurses5-dev libffi-dev \
  libxml2-dev libxslt-dev libcurl4-openssl-dev \
  libicu-dev libsqlite3-dev
