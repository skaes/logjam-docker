FROM stkaes/logjam-code as code
FROM stkaes/logjam-runtime
# this copies ruby, gems and app code on top of all the libs and tools installed in the runtime image
COPY --from=code /opt/logjam /opt/logjam

LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"

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
