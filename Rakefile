begin
  require "bundler/setup"
rescue LoadError
  $stderr.puts "Please install bundler"
end
require "ansi"

ROOT = File.expand_path("..", __FILE__)
LOGJAM_PACKAGE_HOST = (ENV['LOGJAM_PACKAGE_HOST'] || "railsexpress.de") .to_s
LOGJAM_PACKAGE_USER = (ENV['LOGJAM_PACKAGE_USER'] || "uploader").to_s

module LogSystemCommands
  def system(cmd, raise_on_error: true)
    puts
    puts ANSI.green{cmd}
    puts
    if Kernel.system cmd
      return true
    else
      raise "command failed: #{cmd}" if raise_on_error
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
  unless system "docker run --rm -it #{image_name(name)} /bin/bash -l -c '#{arg}'"
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

namespace :code do
  task :build => "builder:build" do
    build_image("code")
  end
  task :test do
    test_image("code")
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
    system "docker rm logjam || true"
    system "docker run --rm -it -h logjam.local -p 80:80 -p 8080:8080 -p 9605:9605 -p 9705:9705 --link logjamdb:logjamdb --link memcache:logjamcache --name logjam #{image_name 'app'}"
  end

  desc "attach to running app container"
  task :attach do
    system "docker exec -it logjam bash"
  end

  desc "upload logjam-app to docker hub"
  task :upload do
    system "docker push stkaes/logjam-app"
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
    system "docker run -d -P --name logjamdb mongo:latest"
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

desc "build all images"
task :build => %w[code:build app:build]

desc "clean unused images and containers"
task :clean do
  system "docker ps -a | awk '/Exited/ {print $1;}' | xargs docker rm", raise_on_error: false
  system "docker images | awk '/none|fpm-(fry|dockery)/ {print $3;}' | xargs docker rmi", raise_on_error: false
end

desc "clean, but also remove all stkaes containers"
task :realclean => :clean do
  system "docker ps -a  | awk '/stkaes/ {print $1;}' | xargs docker rm -f", raise_on_error: false
  system "docker images -a | awk '/stkaes/ {print $3;}' | xargs docker rmi -f", raise_on_error: false
end

desc "delete all containers and images"
task :ultraclean do
  system "docker ps -a -q | xargs docker rm -f", raise_on_error: false
  system "docker images -q | xargs docker rmi -f", raise_on_error: false
end

task :start do
  system("docker-compose up -d")
end

task :stop do
  system("docker-compose stop")
end

task :default => :build

desc "upload images to registry"
task :upload => %w(app:upload)

desc "regenerate TLS certificates (e.g. after IP change)"
task :certify do
  system "docker-machine regenerate-certs default"
end

UBUNTU_VERSION_NAME = { "16.04" => "xenial", "18.04" => "bionic"}
PACKAGES_BUILT_FOR_USR_LOCAL = [:libs, :tools]
PREFIXES = { :opt => "/opt/logjam", :local => "/usr/local" }
SUFFIXES = { :opt => "", :local => "-usr-local" }
KEEP = ENV['KEEP'] == "1" ? "--keep" : ""

namespace :package do
  def scan_and_upload(name)
    upload_dir=`ssh #{LOGJAM_PACKAGE_USER}@#{LOGJAM_PACKAGE_HOST} mktemp -d`.chomp
    Dir.glob("*.deb", base: "packages/#{name}").each do |package|
      if Kernel.system "ssh #{LOGJAM_PACKAGE_USER}@#{LOGJAM_PACKAGE_HOST} debian-package-exists #{name} #{package}"
        puts "package #{name}/#{package} already exists on server"
      else
        system "rsync -vrlptDz -e 'ssh -l #{LOGJAM_PACKAGE_USER}' packages/#{name}/#{package} #{LOGJAM_PACKAGE_HOST}:#{upload_dir}/"
        system "ssh #{LOGJAM_PACKAGE_USER}@#{LOGJAM_PACKAGE_HOST} add-new-debian-packages #{name} #{upload_dir}"
      end
    end
  end

  def cook(package, version, name, location)
    # puts "cooking(#{[package, version, name, location].join(',')})"
    ENV['LOGJAM_PREFIX'] = PREFIXES[location]
    ENV['LOGJAM_SUFFIX'] = SUFFIXES[location]
    options = " --no-cache" if ENV["NOCACHE"]=='1'

    system "fpm-fry cook #{KEEP} --update=always ubuntu:#{version} build_#{package}.rb"
    system "mkdir -p packages/#{name} && mv *.deb packages/#{name}/"
    scan_and_upload(name)
  ensure
    ENV.delete('LOGJAM_PREFIX')
    ENV.delete('LOGJAM_SUFFIX')
  end

  def packages
    [:code, :app]
  end

  def debs
    packages
  end

  UBUNTU_VERSION_NAME.each do |version, name|
    namespace name do
      packages.each do |package|
        PREFIXES.each do |location, prefix|
          next if location == :local && !PACKAGES_BUILT_FOR_USR_LOCAL.include?(package)
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

  namespace :bionic do
    desc "build all bionic packages"
    task :all => packages

    desc "upload all bionic packages"
    task :upload do
      scan_and_upload("bionic")
    end
  end

  namespace :xenial do
    desc "build all xenial packages"
    task :all => packages

    desc "upload all xenial packages"
    task :upload do
      scan_and_upload("xenial")
    end
  end

  desc "cook all packages"
  task :all => %w(bionic:all xenial:all)

  desc "upload images to package host"
  task :upload => %w(bionic:upload xenial:upload)

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

desc "update ubuntu base images with a fresh docker pull"
task :update_base_images do
  %w(16.04 18.04 xenial bionic).each do |version|
    sh "docker pull ubuntu:#{version}"
  end
end
