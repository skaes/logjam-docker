name "logjam-code"
version "0.13"
iteration "12"

vendor "skaes@railsexpress.de"

build_depends "build-essential"
build_depends "curl"
build_depends "git"

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
depends "nodejs"
depends "logjam-ruby", ">= 3.1.2"
depends "logjam-libs", ">= 0.9-2"

apt_setup "apt-get update -y && apt-get install apt-transport-https ca-certificates -y"
apt_setup "echo 'deb [trusted=yes] https://railsexpress.de/packages/ubuntu/#{codename} ./' >> /etc/apt/sources.list"
apt_setup "DEBIAN_FRONTEND=noninteractive apt-get install tzdata -y"

add "images/code/install-code.sh", ".install-code.sh"

run "./.install-code.sh"

plugin "exclude"
exclude "/root/**"
exclude "/root"
exclude "/opt/logjam/**/.git*"
exclude "/opt/logjam/app/tmp/cache/*"
