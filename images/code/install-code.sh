#!/bin/bash
set -e

PATH=/opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

mkdir -p /opt/logjam
cd /opt/logjam

git clone https://github.com/skaes/logjam_app.git app
cd app
git submodule init
git submodule update

export BUNDLE_SILENCE_ROOT_WARNING=1
bundle install --jobs 4 --deployment --without='development test deployment'

mkdir -p log
mkdir -p tmp/sockets
mkdir -p service

export RAILS_ENV=production
bundle exec rake assets:precompile
