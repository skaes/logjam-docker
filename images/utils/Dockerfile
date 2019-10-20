FROM stkaes/logjam-tools as tools
FROM ubuntu:18.04

LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl locales locales-all tzdata

ENV LOGJAM_TOOLS_REVISION a9998033983cad3b7c4588b79ced8ee7bf54c74e
COPY --from=tools /opt/logjam /opt/logjam

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HOME /root
WORKDIR /root
