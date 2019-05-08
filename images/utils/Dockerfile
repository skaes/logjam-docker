FROM stkaes/logjam-tools as tools
FROM ubuntu:18.04

LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl locales locales-all tzdata

ENV LOGJAM_TOOLS_REVISION 5e6eb42e729e01989fed9ff1c7dd6b9c4b0206cb
COPY --from=tools /opt/logjam /opt/logjam

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HOME /root
WORKDIR /root
