FROM stkaes/logjam-tools as tools
FROM ubuntu:16.04

COPY --from=tools /opt/logjam /opt/logjam

LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl locales locales-all tzdata

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HOME /root
WORKDIR /root
