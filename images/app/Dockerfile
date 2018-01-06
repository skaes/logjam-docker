# VERSION         0.1
# DOCKER-VERSION  1.10.2
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam app
#
# TO_BUILD:            docker build -t=stkaes/logjam-app .
# TO_RUN_INTERACTIVE:  docker run --rm -it -p 80:80 -p 8080:8080 --link some-mongo-instance:logjamdb --link some-memcache-instance:logjamcache stkaes/logjamdemo
# ----------------------------
FROM stkaes/logjam-tools as tools
FROM stkaes/logjam-passenger as passenger
FROM stkaes/logjam-code as code
FROM stkaes/logjam-runtime

COPY --from=tools /opt/logjam /opt/logjam
COPY --from=passenger /opt/logjam/ /opt/logjam/
COPY --from=code /opt/logjam/app /opt/logjam/app

LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ENV DEBIAN_FRONTEND noninteractive

# ----------------------------
# services
# ----------------------------
RUN apt-get update && apt-get -y --no-install-recommends install cron && apt-get clean

# ----------------------------
# logjam
# ----------------------------

# this installs packages from ubuntu packages:
# RUN apt-get update && apt-get -y --no-install-recommends install \
#     logjam-libs \
#     logjam-tools \
#     logjam-ruby \
#     logjam-code \
#     logjam-passenger \
#     && apt-get clean

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./etc /etc
ADD ./root /root

WORKDIR /opt/logjam/app
ENV RAILS_ENV production

# we want to run passenger as user logjam, so fix permissions
RUN adduser --gecos '' --no-create-home --home /opt/logjam/app --disabled-login --disabled-password logjam; \
    chown logjam.logjam /opt/logjam/app/config.ru; \
    chown -R logjam.logjam /opt/logjam/app/tmp /opt/logjam/app/log

# setup cron jobs
RUN bundle exec whenever --user logjam --update-crontab --roles cron,worker

# add script to install daemons. will be run by startapp.sh
ADD ./install-daemons.sh /docker/install-daemons.sh

# startapp.sh starts runit and all services
ADD ./startapp.sh /docker/startapp.sh
CMD ["/docker/startapp.sh"]

# application http socket port and websocket port
EXPOSE 80 8080

# importer zeromq ROUTER socket port
EXPOSE 9604

# importer zeromq pull socket port
EXPOSE 9605

# logjam frontend timings collector
EXPOSE 9705

# restore DEBIAN_FRONTEND to default value
ENV DEBIAN_FRONTEND newt
