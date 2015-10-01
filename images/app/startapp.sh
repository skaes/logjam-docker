#!/bin/bash
set -e

# install daemons
/docker/install-daemons.sh

# now we're good to go
echo "starting services"
exec runsvdir -P /etc/service .....................................................
