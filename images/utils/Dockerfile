FROM stkaes/logjam-tools as tools
FROM ubuntu:18.04

LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl locales locales-all tzdata

ENV LOGJAM_TOOLS_REVISION 03ec85dfcd0fbb61178ed1a84b0916ee2653db14
COPY --from=tools /opt/logjam /opt/logjam

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HOME /root
WORKDIR /root
