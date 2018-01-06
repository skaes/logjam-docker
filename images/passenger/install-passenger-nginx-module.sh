#!/bin/bash

PATH=/opt/logjam/bin:$PATH

# now install
passenger-install-nginx-module --auto --auto-download --prefix=/opt/logjam/nginx --languages=ruby
