#!/bin/bash
set -e

echo "preparing daemons"
# this needs to be here as the actual name of the mongo server
# is not known when the container is being built
(cd /opt/logjam/app && bundle exec rake logjam:daemons:install && chown -R logjam.logjam service)

# now we're goog to go
echo "starting services"
exec runsvdir -P /etc/service .....................................................
