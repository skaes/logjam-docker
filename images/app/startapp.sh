#!/bin/bash
set -e

# install daemons
/docker/install-daemons.sh

# remove leftover passenger pid files (unclean shutdown)
rm -f /opt/logjam/app/passenger.*.pid /opt/logjam/app/passenger.*.lock

# now we're good to go
echo "starting services"
exec runsvdir -P /etc/service .....................................................
