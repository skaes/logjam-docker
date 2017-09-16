name "logjam-passenger"
version "0.6"
iteration "2"

vendor "skaes@railsexpress.de"

build_depends "build-essential"
build_depends "curl"
build_depends "git"
build_depends "nodejs"

build_depends "apache2-threaded-dev"
build_depends "libapr1-dev"
build_depends "libcurl4-openssl-dev"
build_depends "libffi-dev"
build_depends "libgdbm-dev"
build_depends "libgmp-dev"
build_depends "libncurses5-dev"
build_depends "libreadline6-dev"
build_depends "libssl-dev"
build_depends "libtool"
build_depends "libyaml-dev"
build_depends "pkg-config"
build_depends "zlib1g-dev"

depends "logjam-ruby", ">= 2.4.2"
depends "apache2"
depends "apache2-mpm-worker"

apt_setup "apt-get update -y && apt-get install apt-transport-https -y"
apt_setup "echo 'deb [trusted=yes] https://railsexpress.de/packages/ubuntu/#{codename} ./' >> /etc/apt/sources.list"

add "images/passenger/install-passenger-apache2-module.sh", ".install-passenger-apache2-module.sh"
add "images/passenger/minify-passenger-apache2-module.sh", ".minify-passenger-apache2-module.sh"
add "images/passenger/passenger.load", ".passenger.load"

run "/opt/logjam/bin/gem", "install", "passenger", "-v", "4.0.60"
run "./.install-passenger-apache2-module.sh"
run "./.minify-passenger-apache2-module.sh"

run "cp", ".passenger.load", "/etc/apache2/mods-available/passenger.load"
run "chmod", "644", "/etc/apache2/mods-available/passenger.load"
