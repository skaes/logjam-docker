#!/bin/bash

cd /opt/logjam/lib/ruby/gems/2.7.0/gems/passenger-6.0.4
rm -rf download_cache debian.template doc dev ext boost packaging man test
find . -name '*.[hc]' -o -name '*.[hc]pp' | xargs rm
find . -name '*.[oa]' -o -name '*.l[oa]' -o -name '*.lai'  | xargs rm
find . -name '*.Plo'  -o -name '*.log' | xargs rm
find . -name configure -o -name config.status -o -name Makefile | xargs rm
