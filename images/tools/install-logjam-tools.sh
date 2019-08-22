#!/bin/bash
set -e

cd logjam-tools
git fetch
git checkout $LOGJAM_TOOLS_REVISION
sh autogen.sh --prefix=/opt/logjam
make all-local
make -j4
make install
