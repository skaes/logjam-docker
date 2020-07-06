name "logjam-code"
version "0.7"
iteration "14"

vendor "skaes@railsexpress.de"

# source "https://github.com/skaes/logjam_app.git"

build_depends "build-essential"
build_depends "curl"
build_depends "git"
build_depends "nodejs"

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

# xenial and bionic base container does not have tzdata anymore
depends "tzdata"
depends "logjam-ruby", ">= 2.7.1"
depends "logjam-libs", ">= 0.7-2"

apt_setup "apt-get update -y && apt-get install apt-transport-https ca-certificates -y"
apt_setup "echo 'deb [trusted=yes] https://railsexpress.de/packages/ubuntu/#{codename} ./' >> /etc/apt/sources.list"
apt_setup "DEBIAN_FRONTEND=noninteractive apt-get install tzdata -y"

add "images/code/install-code.sh", ".install-code.sh"

run "./.install-code.sh"

plugin "exclude"
exclude "/root"
exclude "/opt/logjam/**/.git*"
exclude "/opt/logjam/app/tmp/cache/*"
