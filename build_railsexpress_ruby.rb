name "railsexpress-ruby"
version "2.7.0"
iteration "1"

vendor "skaes@railsexpress.de"

source "https://#{ENV['LOGJAM_PACKAGE_HOST']}/downloads/ruby-2.7.0-p0.tar.gz",
       checksum: '01a73f9a52973a78eb7040ba2d7969e7e9868105bfa8a9a14309a933d8c393ce'

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

run "cd", "ruby-2.7.0-p0"
run "./configure", "--with-out-ext=tcl", "--with-out-ext=tk", "--disable-install-doc", "--enable-shared"
run "make", "-j4"
run "make", "install"
run "cd", ".."
run "mkdir", "-p", "/usr/local/etc"
run "cp", ".gemrc", "/usr/local/etc/gemrc"
# install 1.x version of bundler to allow older Gemfile.locks to work
run "/usr/local/bin/gem", "install", "bundler", "-v", "1.17.3"
# run "/usr/local/bin/gem", "install", "bundler", "-v", "2.1.2"
# run "/usr/local/bin/gem", "update", "-q", "--system", "3.1.2"

plugin "exclude"
exclude "/root/**"
