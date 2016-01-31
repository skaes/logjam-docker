name "logjam-ruby"
version "0.1"
iteration "3"

vendor "skaes@railsexpress.de"

#source "https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.3.tar.gz",
#       checksum: 'df795f2f99860745a416092a4004b016ccf77e8b82dec956b120f18bdc71edce'
#       file_map: {"ruby-2.2.3" => '.'}
source "http://#{ENV['LOGJAM_PACKAGE_HOST']}/downloads/ruby-2.2.4-p230.tar.gz",
       checksum: 'e3043c547c0b6045dec83ac649a7e590d09584064960d764f4649ccbc584b821'

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

run "cd", "ruby-2.2.4-p230"
run "./configure", "--prefix=/opt/logjam", "--with-opt-dir=/opt/logjam",
     "--with-out-ext=tcl", "--with-out-ext=tk", "--disable-install-doc", "--enable-shared"
run "make", "-j4"
run "make", "install"
run "cd", ".."
run "mkdir", "/opt/logjam/etc"
run "cp", ".gemrc", "/opt/logjam/etc/gemrc"
run "/opt/logjam/bin/gem", "update", "-q", "--system"
run "/opt/logjam/bin/gem", "install", "-q", "bundler"
