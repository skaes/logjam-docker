#!/bin/bash

# sanitize environment for passenger-install
source /etc/apache2/envvars
mkdir -p $APACHE_LOG_DIR $APACHE_LOCK_DIR $APACHE_RUN_DIR

# now install
passenger-install-apache2-module --languages ruby
