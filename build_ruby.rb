name "logjam-ruby"
version "2.6.1"
iteration "2"

vendor "skaes@railsexpress.de"

source "https://#{ENV['LOGJAM_PACKAGE_HOST']}/downloads/ruby-2.6.1-p33.tar.gz",
       checksum: '10eb20157a357edcb2aa273dc17783262302ed84c8c18f23e93b718a58503991'

build_depends "autoconf"
build_depends "automake"
build_depends "bison"
build_depends "build-essential"
build_depends "curl"
build_depends "gawk"
build_depends "libffi-dev"
build_depends "libgdbm-dev"
if codename == "bionic"
  build_depends "libgdbm-compat-dev"
end
build_depends "libgmp-dev"
build_depends "libncurses5-dev"
if codename == "bionic"
  build_depends "libreadline-dev"
else
  build_depends "libreadline6-dev"
end
build_depends "libssl-dev"
build_depends "libtool"
build_depends "libyaml-dev"
build_depends "patch"
build_depends "pkg-config"
build_depends "ruby"
build_depends "zlib1g-dev"

depends "libc6"
depends "libffi6"
if codename == "bionic"
  depends "libgdbm5"
else
  depends "libgdbm3"
end
depends "libgmp10"
if codename == "bionic"
  depends "libreadline7"
else
  depends "libreadline6"
end
depends "libyaml-0-2"
depends "openssl"
depends "zlib1g"

add "images/ruby/gemrc", ".gemrc"

run "cd", "ruby-2.6.1-p33"
run "./configure", "--prefix=/opt/logjam", "--with-opt-dir=/opt/logjam",
     "--with-out-ext=tcl", "--with-out-ext=tk", "--disable-install-doc", "--enable-shared"
run "make", "-j4"
run "make", "install"
run "cd", ".."
run "mkdir", "/opt/logjam/etc"
run "cp", ".gemrc", "/opt/logjam/etc/gemrc"
run "/opt/logjam/bin/gem", "install", "bundler", "-v", "1.17.3"
run "/opt/logjam/bin/gem", "update", "-q", "--system", "3.0.3"

plugin "exclude"
exclude "/root/**"
