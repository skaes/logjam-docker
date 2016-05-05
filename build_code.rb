name "logjam-code"
version "0.3"
iteration "3"

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

depends "logjam-ruby"
depends "logjam-libs", ">= 0.3_2"

apt_setup "echo 'deb [trusted=yes] http://railsexpress.de/packages/ubuntu/#{codename} ./' >> /etc/apt/sources.list"

add "images/code/install-code.sh", ".install-code.sh"

run "./.install-code.sh"
