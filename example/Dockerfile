# this is an example docker file to show how to listen for additional log streams
#
# TO_BUILD:            docker build -t=logjam-example .
# TO_RUN_INTERACTIVE:  docker run --rm -it -h lions.local -p 80:80 -p 8080:8080 --link logjamdb:logjamdb --memcache:logjamcache logjam-example

FROM stkaes/logjam-app
MAINTAINER Lion King <lionking@savanna.africa>

ADD ./user_streams.rb /opt/logjam/app/config/initializers/user_streams.rb

# set your local timezone for the container
ENV TZ Europe/Berlin

# Set the bind ip for logjam daemons. Defaults to "127.0.0.1",
# which is appropriate for single machine installs. If you are distributing
# daemon processes across several machines, you must set it to "0.0.0.0."
# If you change this setting in development mode, you must regenerate the
# service definitions by running 'rake logjam:daemons:install'.
ENV LOGJAM_BIND_IP 0.0.0.0

# Set the import threshold (ms). Requests with a response time lower
# than the threshold will not be stored in mongo. Their performance
# data is added to the stats, though.
ENV LOGJAM_IMPORT_THRESHOLD 500

# Ignore requests which start with the following uri prefix
ENV LOGJAM_IGNORED_REQUEST_URI /_system/

# Set how many days we keep request details stored in mongo.
ENV LOGJAM_REQUEST_CLEANING_THRESHOLD 7

# Set how many days we keep statistics around.
ENV LOGJAM_DATABASE_CLEANING_THRESHOLD 28 # 4 weeks
