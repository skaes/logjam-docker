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
    if Kernel.system cmd
      return true
    else
      raise "command failed: #{cmd}"
    end
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
  unless system "docker build -t=#{image_name(name)} #{options} #{image_dir(name)}"
    fail "could not build #{image_name(name)}"
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
      /opt/logjam/lib/ruby/gems/2.3.0/gems/passenger*
      /opt/logjam/lib/ruby/gems/2.3.0/gems/rack*
      /opt/logjam/lib/ruby/gems/2.3.0/gems/daemon*
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
    system "docker run -d -P --name logjamdb mongo:3.0.12"
  end
  task :stop do
    system "docker stop logjamdb"
  end
end

namespace :memcache do
  desc "start a memcached instance"
  task :run do
    system "docker run -d -P --name memcache memcached:1.4.25"
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
  system "docker images | awk '/none|fpm-(fry|dockery)/ {print $3;}' | xargs docker rmi"
end

desc "clean, but also remove all stkaes containers"
task :realclean => :clean do
  system "docker ps -a  | awk '/stkaes/ {print $1;}' | xargs docker rm"
  system "docker images | awk '/stkaes/ {print $3;}' | xargs docker rmi"
end

desc "delete all containers and images"
task :ultraclean do
  system "docker ps -a -q | xargs docker rm -f"
  system "docker images -q | xargs docker rmi -f"
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

UBUNTU_VERSION_NAME = { "14.04" => "trusty", "12.04" => "precise", "16.04" => "xenial" }
PACKAGES_BUILT_FOR_USR_LOCAL = [:libs, :tools]
PACKAGES_BUILT_FOR_PRECISE = [:libs, :tools]
PREFIXES = { :opt => "/opt/logjam", :local => "/usr/local" }
SUFFIXES = { :opt => "", :local => "-usr-local" }

namespace :package do
  def scan_and_upload(name)
    system "docker run -it -v `pwd`/packages/#{name}:/root/tmp stkaes/logjam-builder bash -c 'cd tmp && dpkg-scanpackages . /dev/null | gzip >Packages.gz'"
    system "rsync -vrlptDz -e ssh packages/#{name}/* #{LOGJAM_PACKAGE_HOST}:/var/www/packages/ubuntu/#{name}/"
  end

  def cook(package, version, name, location)
    # puts "cooking(#{[package, version, name, location].join(',')})"
    ENV['LOGJAM_PREFIX'] = PREFIXES[location]
    ENV['LOGJAM_SUFFIX'] = SUFFIXES[location]

    system "fpm-fry cook --keep --update=always ubuntu:#{version} build_#{package}.rb"
    system "mv *.deb packages/#{name}/"
    scan_and_upload(name)
  rescue => e
    $stderr.puts e.message
  ensure
    ENV.delete('LOGJAM_PREFIX')
    ENV.delete('LOGJAM_SUFFIX')
  end

  def packages
    [:libs, :tools, :ruby, :go, :code, :passenger, :app]
  end

  def debs
    packages
  end

  UBUNTU_VERSION_NAME.each do |version, name|
    namespace name do
      packages.each do |package|
        PREFIXES.each do |location, prefix|
          next if location == :local && !PACKAGES_BUILT_FOR_USR_LOCAL.include?(package)
          next if name == "precise" && !PACKAGES_BUILT_FOR_PRECISE.include?(package)
          if location == :opt
            desc "build package #{package} for ubuntu #{version} with install prefix #{prefix}"
            task package do
              cook package, version, name, location
            end
          else
            namespace package do
              desc "build package #{package} for ubuntu #{version} with install prefix #{prefix}"
              task location do
                cook package, version, name, location
              end
            end
          end
        end
      end
    end
  end

  namespace :tools do
    desc "build all tools packages"
    task :all => [:local] + %w(xenial:libs xenial:tools trusty:libs trusty:tools precise:libs precise:tools)
  end

  namespace :xenial do
    desc "build all xenial packages"
    task :all => packages + %w(xenial:libs:local xenial:tools:local)

    desc "upload all xenial packages"
    task :upload do
      scan_and_upload("xenial")
    end

    desc "build package railsexpress_ruby for ubuntu 16.04 with install prefix /usr/local"
    task :railsexpress_ruby do
      cook "railsexpress_ruby", "16.04", "xenial", :local
    end

    desc "build package logjam-go for ubuntu 16.04 with install prefix /usr/local"
    task :go do
      cook "go", "16.04", "xenial", :local
    end
  end

  namespace :trusty do
    desc "build all trusty packages"
    task :all => packages + %w(trusty:libs:local trusty:tools:local)

    desc "upload all trusty packages"
    task :upload do
      scan_and_upload("trusty")
    end

    desc "build package railsexpress_ruby for ubuntu 14.04 with install prefix /usr/local"
    task :railsexpress_ruby do
      cook "railsexpress_ruby", "14.04", "trusty", :local
    end

    desc "build package logjam-go for ubuntu 14.04 with install prefix /usr/local"
    task :go do
      cook "go", "14.04", "trusty", :local
    end
  end

  namespace :precise do
    desc "build all precise packages"
    task :all => %w(precise:go precise:libs precise:tools precise:libs:local precise:tools:local)

    desc "build package go for ubuntu 14.04 with install prefix /usr/local"
    task :go do
      cook "go", "12.04", "precise", :local
    end

    desc "upload all precise packages"
    task :upload do
      scan_and_upload("precise")
    end
  end

  desc "cook all packages which can install in /usr/local"
  task :local => %w(xenial:go xenial:libs:local xenial:tools:local xenial:railsexpress_ruby) +
                 %w(trusty:go trusty:libs:local trusty:tools:local trusty:railsexpress_ruby precise:go precise:libs:local precise:tools:local)

  desc "cook all packages"
  task :all => %w(xenial:all trusty:all precise:all)

  desc "upload images to package host"
  task :upload do
    system "rsync -vrlptDz -e ssh packages/* #{LOGJAM_PACKAGE_HOST}:/var/www/packages/ubuntu"
  end

  namespace :cloud do
    desc "upload images to packagecloud.io"
    task :upload do
      debs.each do |package|
        PREFIXES.each do |location, prefix|
          suffix = SUFFIXES[location]
          UBUNTU_VERSION_NAME.each do |version, name|
            begin
              deb = `ls packages/#{name}/logjam-#{package}#{suffix}*.deb 2>/dev/null`.chomp.split("\n").last
              system "package_cloud push stkaes/logjam/ubuntu/#{name} #{deb}" unless deb.nil?
            rescue => e
              $stderr.puts e.message
            end
          end
        end
      end
    end
  end

  namespace :aptly do
    def url
      ENV['LOGJAM_APTLY_URL']
    end

    def upload(pkg, distribution)
      puts "uploading #{pkg} for #{distribution} to #{url}"
      system "curl -X POST -F 'file=@#{pkg}' #{url}/api/files/#{distribution}"
    end

    def publish(distribution)
      puts "publishing uploaded packages for #{distribution} to #{url}"
      system <<-"CMDS"
      curl -X POST #{url}/api/repos/#{distribution}/file/#{distribution}
      curl -X PUT -H 'Content-Type: application/json' --data '{}' #{url}/api/publish/#{distribution}/#{distribution}
      CMDS
    end

    desc "upload packages to aptly server LOGJAM_APTLY_URL=#{url}"
    task :upload do
      UBUNTU_VERSION_NAME.each do |version, name|
        debs.each do |package|
          PREFIXES.each do |location, prefix|
            suffix = SUFFIXES[location]
            deb = `ls packages/#{name}/logjam-#{package}#{suffix}*.deb 2>/dev/null`.chomp.split("\n").last
            upload(deb, name) unless deb.nil?
          end
        end
        publish(name)
      end
    end
  end
end

def get_latest_commit(repo)
  `curl -s https://api.github.com/repos/skaes/#{repo}/commits/master | grep '"sha":' | head -1 | awk '{print $2;}' | sed 's/[^0-9a-f]//g'`.chomp
end

desc "update commit references for logjam app and tools and optionally LIBS=0|1"
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
