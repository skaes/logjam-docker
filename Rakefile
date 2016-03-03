begin
  require "bundler/setup"
rescue LoadError
  $stderr.puts "Please install bundler"
end
require "ansi"

ROOT = File.expand_path("..", __FILE__)
LOGJAM_PACKAGE_HOST = ENV['LOGJAM_PACKAGE_HOST'].to_s

module LogSystemCommands
  def system(cmd)
    puts
    puts ANSI.green{cmd}
    puts
    Kernel.system cmd
  end
end
class << self
  prepend LogSystemCommands
end

def image_name(name)
  "stkaes/logjam-#{name}"
end

def image_dir(name)
  File.join(ROOT, 'images', name)
end

def export_dir
  File.join(ROOT, 'exports')
end

def build_image(name, options="")
  options += " --no-cache" if ENV["NOCACHE"]=='1'
  Dir.chdir(image_dir(name)) do
    unless system "docker build -t=#{image_name(name)} #{options} ."
      fail "could not build #{image_name(name)}"
    end
  end
end

def test_image(name)
  system "docker run --rm -it -P #{image_name(name)} /bin/bash -l"
end

def run_image(name, arg)
  unless system "docker run --rm -it -v #{export_dir}:/exports #{image_name(name)} /bin/bash -l -c '#{arg}'"
    fail "running image #{image_name(name)} failed"
  end
end

namespace :builder do
  task :build do
    build_image("builder")
  end
  task :test do
    test_image("builder")
  end
end

namespace :libs do
  task :build => "builder:build" do
    build_image("libs")
  end
  task :test do
    test_image("libs")
  end
end

namespace :tools do
  task :build => "libs:build" do
    build_image("tools")
  end
  task :test do
    test_image("tools")
  end
  task :export => :build do
    run_image("tools", "tar czf /exports/opt-logjam-tools.tar.gz /opt/logjam")
  end
end

namespace :ruby do
  task :build => "builder:build" do
    build_image("ruby")
  end
  task :test do
    test_image("ruby")
  end
  task :export => :build do
    run_image("ruby", "tar czf /exports/opt-logjam-ruby.tar.gz /opt/logjam")
  end
end

namespace :code do
  task :build => "ruby:build" do
    build_image("code")
  end
  task :test do
    test_image("code")
  end
  task :export => :build do
    run_image("code", "tar czf /exports/opt-logjam-app.tar.gz /opt/logjam/app")
  end
end

namespace :passenger do
  task :build => "ruby:build" do
    build_image("passenger")
  end
  task :test do
    test_image("passenger")
  end
  task :export => :build do
    exports = %w(
      /opt/logjam/bin/passenger*
      /opt/logjam/lib/ruby/gems/2.2.0/gems/passenger*
      /opt/logjam/lib/ruby/gems/2.2.0/gems/rack*
      /opt/logjam/lib/ruby/gems/2.2.0/gems/daemon*
      /etc/apache2/mods-available/passenger.load
    )
    run_image("passenger", "tar czf /exports/opt-logjam-passenger.tar.gz #{exports.join(' ')}")
  end
  task :run do
    system "docker run --rm -it -P --name passenger #{image_name 'passenger'}"
  end
  desc "attach to running passenger container"
  task :attach do
    system "docker exec -it passenger bash"
  end
end

namespace :runtime do
  task :build do
    build_image("runtime")
  end
  task :test do
    test_image("runtime")
  end
end

namespace :app do
  desc "build the app image"
  task :build => "runtime:build" do
    build_image("app")
  end

  task :test do
    test_image("app")
  end

  desc "run a app container"
  task :run do
    system "docker rm logjam"
    system "docker run --rm -it -h logjam.local -p 80:80 -p 8080:8080 -p 9605:9605 -p 9705:9705 --link logjamdb:logjamdb --link memcache:logjamcache --name logjam #{image_name 'app'}"
  end

  desc "attach to running app container"
  task :attach do
    system "docker exec -it logjam bash"
  end
end

namespace :develop do
  desc "copy build scripts"
  task :scripts do
    system "tar cp `find images -type f | egrep -v 'Dockerfile|develop|.tar.gz'` | tar xpf - -C images/develop --strip-components 2"
  end

  desc "build the develop image"
  task :build => ["builder:build", :scripts] do
    build_image("develop")
  end

  task :test do
    test_image("develop")
  end

  desc "run a develop container"
  task :run do
    system "docker run --rm -it -p 80:80 -p 8080:8080 -p 9605:9605 -p 9705:9705 --link logjamdb:logjamdb --link memcache:logjamcache --name develop -h develop.local #{image_name 'develop'}"
  end

  desc "attach to running develop container"
  task :attach do
    system "docker exec -it develop bash"
  end
end

namespace :logjamdb do
  desc "start a logjamdb instance"
  task :run do
    system "docker run -d -P --name logjamdb mongo:3.0.5"
  end
  task :stop do
    system "docker stop logjamdb"
  end
end

namespace :memcache do
  desc "start a memcached instance"
  task :run do
    system "docker run -d -P --name memcache memcached:1.4.24"
  end
  task :stop do
    system "docker stop memcache"
  end
end

desc "build all end user images"
task :runnables => %w[app:build develop:build]

desc "build all images"
task :build => %w[code:build passenger:build tools:build] do
  Rake::Task[:export].invoke
  Rake::Task[:import].invoke
  Rake::Task[:runnables].invoke
end

desc "export libraries and ruby"
task :export => %w(ruby:export tools:export code:export passenger:export)

desc "import libraries and ruby into build context for app:build"
task :import do
  system "cp -p exports/*.gz images/app/"
end

desc "clean unused images and containers"
task :clean do
  system "docker ps -a | awk '/Exited/ {print $1;}' | xargs docker rm"
  system "docker images | awk '/none/ {print $3;}' | xargs docker rmi"
end

desc "clean, but also remove all stkaes containers"
task :realclean => :clean do
  system "docker ps -a  | awk '/stkaes/ {print $1;}' | xargs docker rm"
  system "docker images | awk '/stkaes/ {print $3;}' | xargs docker rmi"
end

task :start do
  system("docker-compose up -d")
end

task :stop do
  system("docker-compose stop")
end

task :default => :build

desc "upload images to registry"
task :upload do
  system "docker push stkaes/logjam-app"
end

desc "regenerate TLS certificates (e.g. after IP change)"
task :certify do
  system "docker-machine regenerate-certs default"
end

namespace :package do
  def system(cmd)
    raise "build failed!" unless Kernel.system cmd
  end

  def cook(package)
    system "fpm-dockery cook --keep --update=always ubuntu:14.04 build_#{package}.rb"
    system "mv *.deb packages"
    system "docker run -it -v `pwd`/packages:/root/tmp stkaes/logjam-builder bash -c 'cd tmp && dpkg-scanpackages . /dev/null | gzip >Packages.gz'"
    system "rsync -vrlptDz -e ssh packages/* #{LOGJAM_PACKAGE_HOST}:/var/www/packages/ubuntu/trusty"
  end

  def packages
    [:tools, :ruby, :code, :passenger, :app]
  end

  packages.each do |n|
    desc "build logjam #{n} package"
    task n do
      begin
        cook n
      rescue => e
        $stderr.puts e.message
      end
    end
  end

  desc "upload images to package host"
  task :upload do
    system "rsync -vrlptDz -e ssh packages/* #{LOGJAM_PACKAGE_HOST}:/var/www/packages/ubuntu/trusty"
  end

  desc "cook all packages"
  task :all => packages
end

def get_latest_commit(repo)
  `curl -s https://api.github.com/repos/skaes/#{repo}/commits/master | grep '"sha":' | head -1 | awk '{print $2;}' | sed 's/[^0-9a-f]//g'`.chomp
end

desc "update commit references for logjam app and tools and optionalla LIBS=0|1"
task :update_refs do
  files = `grep -rl _REVISION images`.gsub("\n", " ")
  logjam_sha = get_latest_commit("logjam_app")
  # puts "logjam_sha: #{logjam_sha}"
  system "perl -p -i -e 's/LOGJAM_REVISION .*$/LOGJAM_REVISION #{logjam_sha}/' #{files}"
  tools_sha = get_latest_commit("logjam-tools")
  # puts "tools_sha:  #{tools_sha}"
  system "perl -p -i -e 's/LOGJAM_TOOLS_REVISION .*$/LOGJAM_TOOLS_REVISION #{tools_sha}/' #{files}"
  if ENV['LIBS'] == "1"
    system "perl -p -i -e 's/LOGJAM_LIBS_REVISION .*$/LOGJAM_LIBS_REVISION #{tools_sha}/' #{files}"
  end
end
