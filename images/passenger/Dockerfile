# VERSION         0.1
# DOCKER-VERSION  1.10.2
# AUTHORS:        Stefan Kaes <skaes@railsexpress.de>
# DESCRIPTION:    logjam-ruby builder
#
# TO_BUILD:            docker build -t=stkaes/passenger .
# TO_RUN_INTERACTIVE:  docker run --rm -it stkaes/passenger /bin/bash
# ----------------------------
FROM stkaes/logjam-ruby
MAINTAINER Stefan Kaes <skaes@railsexpress.de>
ENV DEBIAN_FRONTEND noninteractive

ENV PATH /opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && \
    apt-get install -y apache2 apache2-mpm-worker apache2-threaded-dev libapr1-dev
RUN gem install passenger -v 4.0.60

ADD ./install-passenger-apache2-module.sh /docker/install-passenger-apache2-module.sh
RUN /docker/install-passenger-apache2-module.sh
ADD ./minify-passenger-apache2-module.sh /docker/minify-passenger-apache2-module.sh
RUN /docker/minify-passenger-apache2-module.sh

ADD ./passenger.load /etc/apache2/mods-available/passenger.load

CMD /usr/sbin/apachectl -D FOREGROUND

EXPOSE 80

# restore DEBIAN_FRONTEND to default value
ENV DEBIAN_FRONTEND newt
