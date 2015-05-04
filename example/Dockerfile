# this is an example docker file to show how to listen for additional log streams
#
# TO_BUILD:            docker build -t=logjam-example .
# TO_RUN_INTERACTIVE:  docker run --rm -it -h lions.local -p 80:80 -p 8080:8080 --link logjamdb:logjamdb --memcahe:logjamchache logjam-example

FROM stkaes/logjam-app
MAINTAINER Lion King <lionking@savanna.africa>

ADD ./user_streams.rb /opt/logjam/app/config/initializers/user_streams.rb
