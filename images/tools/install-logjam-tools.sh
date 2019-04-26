#!/bin/bash
set -e

cd logjam-tools
sh autogen.sh --prefix=/opt/logjam
make -j4
make install
