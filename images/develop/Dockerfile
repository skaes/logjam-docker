# VERSION         0.1
# DOCKER-VERSION  1.6.0
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam app
#
# TO_BUILD:            docker build -t=stkaes/logjam-develop .
# TO_RUN_INTERACTIVE:  docker run --rm -it -p 80:80 -p 8080:8080 --link some-mongo-instance:logjamdb --link some-memcache-instance:logjamcache stkaes/logjam-develop
# ----------------------------
FROM stkaes/logjam-builder
MAINTAINER Stefan Kaes <skaes@railsexpress.de>
ENV DEBIAN_FRONTEND noninteractive

# ----------------------------
# tools and runtime support
# ----------------------------
RUN apt-get install -y --no-install-recommends runit sudo lsof curl wget htop gawk emacs23-nox

# ----------------------------
# performance tools
# ----------------------------
RUN apt-get install -y --no-install-recommends libunwind8 libunwind8-dev graphviz ghostscript
RUN git clone https://github.com/skaes/gperftools.git
RUN cd gperftools && sh autogen.sh && ./configure --prefix=/usr && make && make install

# ----------------------------
# ruby
# ----------------------------
RUN apt-get install -y --no-install-recommends ruby
ADD ./install-ruby.sh /docker/install-ruby.sh
RUN /bin/bash -l -c '/docker/install-ruby.sh ruby-2.2.2-p95'
ADD ./gemrc /opt/logjam/etc/gemrc
ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN gem update -q --system
RUN gem install -q bundler

# ----------------------------
# web server
# ----------------------------
RUN apt-get install -y --no-install-recommends \
    apache2 apache2-mpm-worker apache2-threaded-dev libapr1-dev
RUN gem install passenger -v 4.0.59
ADD ./install-passenger-apache2-module.sh /docker/install-passenger-apache2-module.sh
RUN /docker/install-passenger-apache2-module.sh
ADD ./passenger.load /etc/apache2/mods-available/passenger.load

# ----------------------------
# logjam - libraries
# ----------------------------
ENV LOGJAM_TOOLS_REVISION 321cac81b08c229a9da10002f9cfb6dcb8ce73b7
ADD ./install-logjam-libs.sh /docker/install-logjam-libs.sh
RUN /bin/bash -l -c /docker/install-logjam-libs.sh

# ----------------------------
# logjam - binaries
# ----------------------------
ENV LOGJAM_TOOLS_REVISION 321cac81b08c229a9da10002f9cfb6dcb8ce73b7
ADD ./install-logjam-tools.sh /docker/install-logjam-tools.sh
RUN /bin/bash -l -c /docker/install-logjam-tools.sh

# ----------------------------
# logjam - app
# ----------------------------
ENV LOGJAM_REVISION cea8a804f10a1de9be4c03a36ce437eeff38ca0e
ADD ./install-code.sh /docker/install-code.sh
RUN /bin/bash -l -c /docker/install-code.sh

# ----------------------------
# logjam
# ----------------------------
ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./etc /etc
ADD ./root /root
RUN a2enmod expires headers rewrite passenger
RUN a2dissite 000-default
RUN a2ensite logjam

WORKDIR /opt/logjam/app
ENV RAILS_ENV production

# we want to run passenger as user logjam, so fix permissions
RUN addgroup --gid 500 logjam; \
    adduser --gecos '' --no-create-home --home /opt/logjam/app --disabled-login --disabled-password --uid 500 --gid 500 logjam; \
    chown logjam.logjam /opt/logjam/app/config.ru; \
    chown -R logjam.logjam /opt/logjam/app/tmp /opt/logjam/app/log

RUN bundle exec whenever --user logjam --update-crontab --roles cron,worker
RUN LOGJAM_PRODUCTION_DB=DB_PLACE_HOLDER bundle exec rake logjam:daemons:install ; chown -R logjam.logjam /opt/logjam/app/service

ADD ./startapp.sh /docker/startapp.sh
CMD /docker/startapp.sh

# application http socket port and websocket port
EXPOSE 80 8080

# importer zeromq pull socket port
EXPOSE 9605

# restore DEBIAN_FRONTEND to default value
ENV DEBIAN_FRONTEND newt
