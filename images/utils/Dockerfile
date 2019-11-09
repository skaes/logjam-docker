FROM stkaes/logjam-tools as tools
FROM ubuntu:18.04

LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl locales locales-all tzdata

ENV LOGJAM_TOOLS_REVISION 4b1093eae570b8d97e1d4c041f02cefd31b254e9
COPY --from=tools /opt/logjam /opt/logjam

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HOME /root
WORKDIR /root
