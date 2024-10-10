#!/bin/bash
bundle exec rake logjam:daemons:install
chown -R logjam:logjam /opt/logjam/app/service
