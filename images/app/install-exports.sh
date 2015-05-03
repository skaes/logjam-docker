#!/bin/bash

cd /

tar xzpf /imports/logjam-tools.tar.gz
tar xzpf /imports/logjam-ruby.tar.gz
tar xzpf /import/logjam-app.tar.gz
tar xzpf /import/logjam-passenger.tar.gz

addgroup --gid 500 logjam ; mkdir -p /opt/logjam/app
adduser --gecos '' --no-create-home --home /opt/logjam/app --disabled-login --disabled-password --uid 500 --gid 500 logjam

chown -R logjam:logjam /opt/logjam/app
