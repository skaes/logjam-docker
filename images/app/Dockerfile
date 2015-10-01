# VERSION         0.1
# DOCKER-VERSION  1.7.1
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam app
#
# TO_BUILD:            docker build -t=stkaes/logjam-app .
# TO_RUN_INTERACTIVE:  docker run --rm -it -p 80:80 -p 8080:8080 --link some-mongo-instance:logjamdb --link some-memcache-instance:logjamcache stkaes/logjamdemo
# ----------------------------
FROM stkaes/logjam-runtime
MAINTAINER Stefan Kaes <skaes@railsexpress.de>
ENV DEBIAN_FRONTEND noninteractive

# ----------------------------
# web server
# ----------------------------
RUN apt-get -y --no-install-recommends install apache2 && apt-get clean
RUN a2enmod expires headers rewrite

# ----------------------------
# logjam
# ----------------------------
ADD ./opt-logjam-tools.tar.gz /
ADD ./opt-logjam-ruby.tar.gz /
ADD ./opt-logjam-app.tar.gz /
ADD ./opt-logjam-passenger.tar.gz /
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
RUN a2enmod passenger
RUN a2dissite 000-default
RUN a2ensite logjam

WORKDIR /opt/logjam/app
ENV RAILS_ENV production

# we want to run passenger as user logjam, so fix permissions
RUN adduser --gecos '' --no-create-home --home /opt/logjam/app --disabled-login --disabled-password logjam; \
    chown logjam.logjam /opt/logjam/app/config.ru; \
    chown -R logjam.logjam /opt/logjam/app/tmp /opt/logjam/app/log

# setup cron jobs
RUN bundle exec whenever --user logjam --update-crontab --roles cron,worker

# install daemons. this needs to be run again in any derived container
# after adding user configuration parameters.
ADD ./install-daemons.sh /docker/install-daemons.sh
RUN /docker/install-daemons.sh

# startapp.sh starts runit and all services
ADD ./startapp.sh /docker/startapp.sh
CMD /docker/startapp.sh

# application http socket port and websocket port
EXPOSE 80 8080

# importer zeromq pull socket port
EXPOSE 9605

# logjam frontend timings collector
EXPOSE 9705

# restore DEBIAN_FRONTEND to default value
ENV DEBIAN_FRONTEND newt
