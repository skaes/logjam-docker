prefix = ENV['LOGJAM_PREFIX']
suffix = ENV['LOGJAM_SUFFIX']

name "logjam-tools#{suffix}"
version "0.3"
iteration "5"

vendor "skaes@railsexpress.de"

source "https://github.com/skaes/logjam-tools.git"

# plugin "exclude"
# exclude "#{prefix}/share/man"
# exclude "#{prefix}/share/doc"
# exclude "/usr/share/doc"
# exclude "/usr/share/man"

build_depends "build-essential"
build_depends "autoconf"
build_depends "automake"
build_depends "libtool"
build_depends "pkg-config"
build_depends "git"
build_depends "wget"
build_depends "libssl-dev"
build_depends "zlib1g-dev"

depends "logjam-libs#{suffix}", ">= 0.3-4"

apt_setup "echo 'deb [trusted=yes] http://railsexpress.de/packages/ubuntu/#{codename} ./' >> /etc/apt/sources.list"

files "#{prefix}/bin/logjam-*"

run "./autogen.sh", "--prefix=#{prefix}"
run "make", "-j4"
run "make", "install"
