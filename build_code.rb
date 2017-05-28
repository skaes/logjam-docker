name "logjam-code"
version "0.6"
iteration "4"

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

depends "logjam-ruby", ">= 2.4.1"
depends "logjam-libs", ">= 0.4-1"

apt_setup "apt-get update -y && apt-get install apt-transport-https -y"
apt_setup "echo 'deb [trusted=yes] https://railsexpress.de/packages/ubuntu/#{codename} ./' >> /etc/apt/sources.list"

add "images/code/install-code.sh", ".install-code.sh"

run "./.install-code.sh"

plugin "exclude"
exclude "/root"
exclude "/opt/logjam/**/.git*"
exclude "/opt/logjam/app/tmp/cache/*"
