#!/bin/bash
RAILS_ENV=${LOGJAM_ENV:-$RAILS_ENV} bundle exec rake logjam:daemons:install
chown -R logjam.logjam /opt/logjam/app/service
