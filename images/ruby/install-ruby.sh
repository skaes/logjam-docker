#!/bin/bash
set -e

ruby_version=$1
curl -s https://railsexpress.de/downloads/${ruby_version}.tar.gz | tar xz
cd $ruby_version
autoconf
./configure --prefix=/opt/logjam --enable-shared --disable-install-doc --with-out-ext=tcl --with-out-ext=tk
make -j4
make install
