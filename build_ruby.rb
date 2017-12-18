name "logjam-ruby"
version "2.4.3"
iteration "1"

vendor "skaes@railsexpress.de"

source "http://#{ENV['LOGJAM_PACKAGE_HOST']}/downloads/ruby-2.4.3-p205.tar.gz",
       checksum: '8ca8805253084f8ae1a5f1b3c8cb4a2b064bad6274836e2b880013e38b8c28d2'

build_depends "autoconf"
build_depends "automake"
build_depends "bison"
build_depends "build-essential"
build_depends "curl"
build_depends "gawk"
build_depends "libffi-dev"
build_depends "libgdbm-dev"
build_depends "libgmp-dev"
build_depends "libncurses5-dev"
build_depends "libreadline6-dev"
build_depends "libssl-dev"
build_depends "libtool"
build_depends "libyaml-dev"
build_depends "patch"
build_depends "pkg-config"
build_depends "ruby"
build_depends "zlib1g-dev"

depends "libc6"
depends "libffi6"
depends "libgdbm3"
depends "libgmp10"
depends "libreadline6"
depends "libyaml-0-2"
depends "openssl"
depends "zlib1g"

add "images/ruby/gemrc", ".gemrc"

run "cd", "ruby-2.4.3-p205"
run "./configure", "--prefix=/opt/logjam", "--with-opt-dir=/opt/logjam",
     "--with-out-ext=tcl", "--with-out-ext=tk", "--disable-install-doc", "--enable-shared"
run "make", "-j4"
run "make", "install"
run "cd", ".."
run "mkdir", "/opt/logjam/etc"
run "cp", ".gemrc", "/opt/logjam/etc/gemrc"
run "/opt/logjam/bin/gem", "update", "-q", "--system"
