#!/bin/bash
set -e

PATH=/opt/logjam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

mkdir -p /opt/logjam
cd /opt/logjam

git clone https://github.com/skaes/logjam_app.git app
cd app
git submodule init
git submodule update

export BUNDLE_SILENCE_ROOT_WARNING=1
case $(bundle version | awk '{print $3}') in
    1.*)
        bundle install --jobs 4 --deployment --without='development test deployment'
        ;;
    2.*)
        bundle config --local deployment true
        bundle config --local path /opt/logjam/app/vendor/bundle
        bundle config --local without development test deployment
        bundle install --jobs 4
        ;;
    *)
        echo "unsupported bundler version" 1>&2
        exit 1
        ;;
esac

# remove compiled objects
ruby_library_version=$(ruby -e 'puts RUBY_VERSION.sub(/\.\d\z/, ".0")')
gem_dir=./vendor/bundle/ruby/${ruby_library_version}/gems
ext_dirs=$(find $gem_dir -type d -name ext -prune)
if [ "$ext_dirs" != "" ]; then
    find $ext_dirs -name '*.o' | xargs rm -f
fi

mkdir -p log
mkdir -p tmp/sockets
mkdir -p service

# For now, asset compilation is not necessary as we use local
# pre-compilation and github. Uncomment if we reverse this decision.
# export RAILS_ENV=production
# bundle exec rake assets:precompile
