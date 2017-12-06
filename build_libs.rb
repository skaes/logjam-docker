prefix = ENV['LOGJAM_PREFIX']
suffix = ENV['LOGJAM_SUFFIX']

name "logjam-libs#{suffix}"
version "0.5"
iteration "1"

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

files "#{prefix}/bin/[^l]*"
files "#{prefix}/include/*"
files "#{prefix}/lib/*"
files "#{prefix}/share/*"

depends "libc6"
depends "zlib1g"
depends "openssl"

run "./bin/install-libs", "--prefix=#{prefix}"

after_install <<-"EOS"
#!/bin/bash
ldconfig
EOS
