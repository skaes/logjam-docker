name "logjam-tools"
version "0.1"
iteration "3"

vendor "skaes@railsexpress.de"

source "https://github.com/skaes/logjam-tools.git"

# plugin "exclude"
# exclude "/opt/logjam/share/man"
# exclude "/opt/logjam/share/doc"
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

depends "logjam-libs", "#{version}-#{iteration}"

package "logjam-libs" do
  files "/opt/logjam/bin/[^l]*"
  files "/opt/logjam/include/*"
  files "/opt/logjam/lib/*"
  files "/opt/logjam/share/*"

  depends "libc6"
  depends "zlib1g"
  depends "openssl"
end

files "/opt/logjam/bin/logjam-*"

run "./bin/install-libs", "--prefix=/opt/logjam"
run "./autogen.sh", "--prefix=/opt/logjam", "--with-opt-dir=/opt/logjam"
run "make", "-j4"
run "make", "install"
