# VERSION         0.1
# DOCKER-VERSION  1.10.2
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam base builder package
#
# TO_BUILD:            docker build -t=stkaes/builder .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/builder
# ----------------------------
FROM ubuntu:16.04
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

# ----------------------------
# Environment (can be used in scripts)
# ----------------------------
ENV HOME /root
WORKDIR /root

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
        patch \
        pkg-config \
        sudo \
        wget \
        zlib1g-dev

# install go compiler
ENV GOLANG_VERSION 1.11.1
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 2871270d8ff0c8c69f161aaae42f9f28739855ff5c5204752a8d92a1c9f63993
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
        && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
        && tar -C /usr/local -xzf golang.tar.gz \
        && rm golang.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
