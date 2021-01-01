FROM stkaes/logjam-builder
LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"
ARG DEBIAN_FRONTEND=noninteractive

# ----------------------------
# tools and runtime support
# ----------------------------
RUN apt-get update
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
RUN /bin/bash -l -c '/docker/install-ruby.sh ruby-2.7.2-p137'
ADD ./gemrc /opt/logjam/etc/gemrc
ENV PATH /opt/logjam/bin:/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# RUN gem update -q --system 3.1.2

# ----------------------------
# web server
# ----------------------------
RUN apt-get install -y --no-install-recommends \
    apache2 apache2-mpm-worker apache2-threaded-dev libapr1-dev
RUN gem install passenger -v 6.0.5
ADD ./install-passenger-apache2-module.sh /docker/install-passenger-apache2-module.sh
RUN /docker/install-passenger-apache2-module.sh
ADD ./passenger.load /etc/apache2/mods-available/passenger.load

# ----------------------------
# logjam - libraries
# ----------------------------
ENV LOGJAM_LIBS_REVISION 07cb0f8a3c21185972a4cb58c997dc5c41afee2c
ADD ./install-logjam-libs.sh /docker/install-logjam-libs.sh
RUN /bin/bash -l -c /docker/install-logjam-libs.sh

# ----------------------------
# logjam - binaries
# ----------------------------
ENV LOGJAM_TOOLS_REVISION f63c9f2fcc86aeca41e46904e34ffa8c389cef31
ADD ./install-logjam-tools.sh /docker/install-logjam-tools.sh
RUN /bin/bash -l -c /docker/install-logjam-tools.sh

# ----------------------------
# logjam - app
# ----------------------------
RUN apt-get -y --no-install-recommends install nodejs && apt-get clean
ENV LOGJAM_REVISION 4f5b1bd301da8fa419d641bb15267c77797e196b

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

ADD ./install-daemons.sh /docker/install-daemons.sh
ADD ./startapp.sh /docker/startapp.sh
CMD ["/docker/startapp.sh"]

# application http socket port and websocket port
EXPOSE 80 8080

# importer zeromq pull socket port
EXPOSE 9605
