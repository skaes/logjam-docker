FROM ubuntu:18.04
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

# ----------------------------
# Environment (can be used in scripts)
# ----------------------------
ENV HOME /root
WORKDIR /root

# ----------------------------
# allow packages from the logjam package cloud repo
# ----------------------------
RUN apt-get update && apt-get install -y apt-transport-https curl gnupg locales locales-all tzdata
# if we don't install curl, https transport for apt won't work
# ADD packagecloud.gpg.key /etc/apt/packagecloud.gpg.key
# RUN apt-key add /etc/apt/packagecloud.gpg.key
# ADD stkaes_logjam.list /etc/apt/sources.list.d/stkaes_logjam.list
# RUN apt-get update -y
# alternative which requires a bit more trust
# RUN apt-get install -y curl && (curl -s https://packagecloud.io/install/repositories/stkaes/logjam/script.deb.sh | bash)

# ----------------------------
# set locale
# ----------------------------
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# ----------------------------
# runtime packages
# ----------------------------
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    gawk \
    htop \
    net-tools \
    libcurl4 \
    libffi6 \
    libgdbm5 \
    libgmp10 \
    libicu60 \
    libncurses5 \
    libreadline7 \
    libsqlite3-0 \
    libssl1.0.0 \
    libxml2 \
    libxslt1.1 \
    libyaml-0-2 \
    lsof \
    less \
    runit \
    sudo  \
    wget \
    zlib1g \
    && apt-get clean
