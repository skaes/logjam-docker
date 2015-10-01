#!/bin/bash
LOGJAM_PRODUCTION_DB=DB_PLACE_HOLDER bundle exec rake logjam:daemons:install
chown -R logjam.logjam /opt/logjam/app/service
