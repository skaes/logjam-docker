# VERSION         0.1
# DOCKER-VERSION  1.6.0
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>, Jochen Kramer <freetwix@web.de>
# DESCRIPTION:    logjam demo
#
# TO_BUILD:            docker build -t=stkaes/logjam-app .
# TO_RUN_INTERACTIVE:  docker run --rm -i -t -p 80:80 -p 8080:8080 --link whatever:logjamdb stkaes/logjamdemo
# ----------------------------
FROM stkaes/logjam-runtime
MAINTAINER Stefan Kaes

# ----------------------------
# memcache
# ----------------------------
RUN apt-get -y --no-install-recommends install memcached && apt-get clean

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

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./etc /etc
RUN a2enmod passenger
RUN a2dissite 000-default
RUN a2ensite logjam

WORKDIR /opt/logjam/app
ENV RAILS_ENV production
RUN bundle exec rake logjam:daemons:install
ADD ./startapp.sh /docker/startapp.sh
CMD /docker/startapp.sh

EXPOSE 80 8080
