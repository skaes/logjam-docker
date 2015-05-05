#!/bin/bash
set -e

# insert actual database hostname into importer config
DB_EXPR="(ENV['LOGJAM_PRODUCTION_DB'] || ENV['LOGJAMDB_NAME'] || 'localhost').split('/').last"
DB_NAME=`ruby -e "puts $DB_EXPR"`
sed -i -e "s/DB_PLACE_HOLDER/${DB_NAME}/" /opt/logjam/app/service/importer/importer.conf

# now we're good to go
echo "starting services"
exec runsvdir -P /etc/service .....................................................
