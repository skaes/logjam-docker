FROM stkaes/logjam-code as code
FROM stkaes/logjam-runtime
# this copies ruby, gems and app code on top of all the libs and tools installed in the runtime image
COPY --from=code /opt/logjam /opt/logjam

LABEL maintainer "Stefan Kaes <skaes@railsexpress.de>"

ENV PATH=/opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./etc /etc
ADD ./root /root

WORKDIR /opt/logjam/app
ENV RAILS_ENV=production

# we want to run passenger as user logjam, so fix permissions
RUN adduser --gecos '' --no-create-home --home /opt/logjam/app --disabled-login --disabled-password logjam; \
    chown logjam.logjam /opt/logjam/app/config.ru; \
    chown -R logjam.logjam /opt/logjam/app/tmp /opt/logjam/app/log

# setup cron jobs
RUN bundle exec whenever --user logjam --update-crontab --roles cron,worker

# add script to install daemons. will be run by startapp.sh
ADD ./install-daemons.sh /docker/install-daemons.sh

# download passenger support binaries and build native support runtime
RUN passenger-config install-standalone-runtime
RUN passenger-config build-native-support

# now prohibit passenger compiles/downloads
ENV PASSENGER_COMPILE_NATIVE_SUPPORT_BINARY=0
ENV PASSENGER_DOWNLOAD_NATIVE_SUPPORT_BINARY=0

# startapp.sh starts runit and all services
ADD ./startapp.sh /docker/startapp.sh
CMD ["/docker/startapp.sh"]

# application http socket port and websocket port
EXPOSE 80 8080

# importer zeromq device ports
EXPOSE 9604 9605 9606

# logjam frontend timings collector
EXPOSE 9705
