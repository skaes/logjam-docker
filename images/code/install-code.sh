#!/bin/bash
set -e

apt-get -y --no-install-recommends install nodejs && apt-get clean

mkdir -p /opt/logjam
cd /opt/logjam

git clone https://github.com/skaes/logjam_app.git app
cd app
git submodule init
git submodule update
bundle install --jobs 4 --deployment --without='development test deployment'
mkdir -p log
mkdir -p tmp/sockets
mkdir -p service

export RAILS_ENV=production
bundle exec rake assets:precompile
