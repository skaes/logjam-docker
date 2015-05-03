# VERSION         0.1
# DOCKER-VERSION  1.6.0
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam demo
#
# TO_BUILD:            docker build -t=stkaes/logjam-app .
# TO_RUN_INTERACTIVE:  docker run --rm -it -p 80:80 -p 8080:8080 --link some-mongo-instance:logjamdb stkaes/logjamdemo
# ----------------------------
FROM stkaes/logjam-runtime
MAINTAINER Stefan Kaes <skaes@railsexpress.de>

# ----------------------------
# web server
# ----------------------------
RUN apt-get -y --no-install-recommends install apache2 && apt-get clean
RUN a2enmod expires headers rewrite

# ----------------------------
# logjam
# ----------------------------
RUN addgroup --gid 500 logjam ; mkdir -p /opt/logjam/app
RUN adduser --gecos '' --no-create-home --home /opt/logjam/app --disabled-login --disabled-password --uid 500 --gid 500 logjam
ADD ./opt-logjam-tools.tar.gz /
ADD ./opt-logjam-ruby.tar.gz /
ADD ./opt-logjam-app.tar.gz /
ADD ./opt-logjam-passenger.tar.gz /

# for passenger user switching to work, we need this:
RUN addgroup --gid 500 logjam; \
    adduser --gecos '' --no-create-home --home /opt/logjam/app --disabled-login --disabled-password --uid 500 --gid 500 logjam;\
    chown -R logjam:logjam /opt/logjam/app

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
