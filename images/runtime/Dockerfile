# VERSION         0.1
# DOCKER-VERSION  1.7.1
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam base runtime package
#
# TO_BUILD:            docker build -t=stkaes/runtime .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/runtime
# ----------------------------
FROM ubuntu:14.04
MAINTAINER Stefan Kaes <skaes@railsexpress.de>

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
  runit sudo lsof curl wget htop gawk \
  zlib1g libyaml-0-2 libssl1.0.0 libgdbm3 \
  libreadline6 libncurses5 libffi6 \
  libxml2 libxslt1.1 libcurl3 \
  libicu52 libsqlite3-0 && apt-get clean
