#!/bin/bash
set -e

cd logjam-tools
git pull
sh autogen.sh --prefix=/opt/logjam --with-opt-dir=/opt/logjam
make -j4
make install
