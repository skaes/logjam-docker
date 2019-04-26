#!/bin/bash
set -e

git clone https://github.com/skaes/logjam-tools.git
cd logjam-tools
git checkout $LOGJAM_LIBS_REVISION
./bin/install-libs --prefix=/opt/logjam
