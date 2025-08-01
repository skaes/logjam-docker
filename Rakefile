begin
  require "bundler/setup"
rescue LoadError
  $stderr.puts "Please install bundler"
end
require "ansi"

ROOT = File.expand_path("..", __FILE__)
LOGJAM_PACKAGE_HOST = (ENV['LOGJAM_PACKAGE_HOST'] || "railsexpress.de") .to_s
LOGJAM_PACKAGE_USER = (ENV['LOGJAM_PACKAGE_USER'] || "uploader").to_s
LOGJAM_PACKAGE_UPLOAD = ENV['LOGJAM_PACKAGE_UPLOAD'] != '0'

ARCH = ENV['ARCH'] || RUBY_PLATFORM.split('-').first.sub('x86_64','amd64')
PLATFORM = "--platform linux/#{ARCH}"
LIBARCH = ARCH.sub('arm64', 'arm64v8') + "/"
PROGRESS = "--progress #{ENV['PROGRESS'] || 'plain'}"

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
  "stkaes/logjam-#{name}:latest-#{ARCH}"
end

def image_dir(name)
  File.join(ROOT, 'images', name)
end

def build_image(name, options="")
  options += " --no-cache" if ENV["NOCACHE"]=='1'
  unless system "docker build #{PROGRESS} #{PLATFORM} --build-arg TARGETARCH=#{ARCH} -t=#{image_name(name)} #{options} #{image_dir(name)}"
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
    system "docker push stkaes/logjam-app:latest-#{ARCH}"
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
  system "docker ps -a | awk '/Exited|Created/ {print $1;}' | xargs docker rm", raise_on_error: false
  system "docker images | awk '/<none>/ {print $3;}' | xargs docker rmi", raise_on_error: false
  system "docker images | awk '/(fpm-(fry|dockery))|([a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+)|(.*-v[0-9]+-stefankaes)/ {print $1 \":\" $2;}' | xargs docker rmi", raise_on_error: false
end

desc "clean, but also remove all stkaes containers"
task :realclean => :clean do
  system "docker ps -a  | awk '/stkaes/ {print $1;}' | xargs docker rm -f", raise_on_error: false
  system "docker images -a | awk '/stkaes/ {print $1 \":\" $2;}' | xargs docker rmi -f", raise_on_error: false
end

desc "delete all containers and images"
task :ultraclean do
  system "docker ps -a -q | xargs docker rm -f", raise_on_error: false
  system "docker images -q | xargs docker rmi -f", raise_on_error: false
end

task :start do
  system("docker tag stkaes/logjam-app:latest-#{ARCH} stkaes/logjam-app:latest")
  system("docker-compose up -d")
end

task :stop do
  system("docker-compose stop")
end

task :down do
  system("docker-compose down")
end

task :default => :build

desc "upload images to registry"
task :upload => %w(app:upload)

desc "create latest multi platform manifest"
task :manifest do
  repo = "stkaes/logjam-app"
  system "docker manifest rm #{repo}:latest 2>/dev/null || true"
  system "docker manifest create #{repo}:latest --amend #{repo}:latest-amd64 --amend #{repo}:latest-arm64"
  system "docker manifest push --purge #{repo}:latest"
end

desc "create stable multi platform manifest"
task :stable do
  repo = "stkaes/logjam-app"
  system "docker manifest rm #{repo}:stable 2>/dev/null || true"
  system "docker manifest create #{repo}:stable --amend #{repo}:latest-amd64 --amend #{repo}:latest-arm64"
  system "docker manifest push --purge #{repo}:stable"
end

desc "regenerate TLS certificates (e.g. after IP change)"
task :certify do
  system "docker-machine regenerate-certs default"
end

UBUNTU_VERSIONS = %w(focal jammy noble)
PACKAGES_BUILT_FOR_USR_LOCAL = [:libs, :tools]
PREFIXES = { :opt => "/opt/logjam", :local => "/usr/local" }
SUFFIXES = { :opt => "", :local => "-usr-local" }
KEEP = ENV['KEEP'] == "1" ? "--keep" : ""
LOGJAM_REVISION = `awk -F' ' '/LOGJAM_REVISION/ {print $3};' images/code/Dockerfile`.chomp

namespace :package do
  def scan_and_upload(name)
    return unless LOGJAM_PACKAGE_UPLOAD
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

  def cook(package, name, location)
    # puts "cooking(#{[package, name, location].join(',')}) LOGJAM_REVISION=#{LOGJAM_REVISION}"
    ENV['LOGJAM_PREFIX'] = PREFIXES[location]
    ENV['LOGJAM_SUFFIX'] = SUFFIXES[location]
    ENV['LOGJAM_REVISION'] = LOGJAM_REVISION
    ENV['RUBYOPT'] = '-W0'

    system "fpm-fry cook #{KEEP} #{PLATFORM} --pull --update=always #{LIBARCH}ubuntu:#{name} build_#{package}.rb"
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

  UBUNTU_VERSIONS.each do |name|
    namespace name do
      packages.each do |package|
        PREFIXES.each do |location, prefix|
          next if location == :local && !PACKAGES_BUILT_FOR_USR_LOCAL.include?(package)
          if location == :opt
            desc "build package #{package} for ubuntu #{name} with install prefix #{prefix}"
            task package do
              cook package, name, location
            end
          else
            namespace package do
              desc "build package #{package} for ubuntu #{name} with install prefix #{prefix}"
              task location do
                cook package, name, location
              end
            end
          end
        end
      end
    end
  end

  namespace :noble do
    desc "build all noble packages"
    task :all => packages

    desc "upload all noble packages"
    task :upload do
      scan_and_upload("noble")
    end
  end

  namespace :jammy do
    desc "build all jammy packages"
    task :all => packages

    desc "upload all jammy packages"
    task :upload do
      scan_and_upload("jammy")
    end
  end

  namespace :focal do
    desc "build all focal packages"
    task :all => packages

    desc "upload all focal packages"
    task :upload do
      scan_and_upload("focal")
    end
  end

  desc "cook all packages"
  task :all => %w(noble:all jammy:all focal:all)

  desc "upload images to package host"
  task :upload => %w(noble:upload jammy:upload focal:upload)
end

def get_latest_commit(repo)
  `curl -s https://api.github.com/repos/skaes/#{repo}/commits/master | grep '"sha":' | head -1 | awk '{print $2;}' | sed 's/[^0-9a-f]//g'`.chomp
end

desc "update commit references for logjam app and tools and optionally LIBS=0|1"
task :update_refs do
  files = `grep -rl '_REVISION=' images`.gsub("\n", " ")
  logjam_sha = get_latest_commit("logjam_app")
  # puts "logjam_sha: #{logjam_sha}"
  system "perl -p -i -e 's/LOGJAM_REVISION=.*$/LOGJAM_REVISION=#{logjam_sha}/' #{files}"
  tools_sha = get_latest_commit("logjam-tools")
  # puts "tools_sha:  #{tools_sha}"
  system "perl -p -i -e 's/LOGJAM_TOOLS_REVISION=.*$/LOGJAM_TOOLS_REVISION=#{tools_sha}/' #{files}"
  if ENV['LIBS'] == "1"
    system "perl -p -i -e 's/LOGJAM_LIBS_REVISION=.*$/LOGJAM_LIBS_REVISION=#{tools_sha}/' #{files}"
  end
end

desc "update ubuntu base images with a fresh docker pull"
task :update_base_images do
  %w(20.04 22.04 24.04 focal jammy noble).each do |version|
    sh "docker pull ubuntu:#{version}"
  end
end

desc "increment package versions"
task :increment_versions do
  file_name = Pathname.new(__dir__)+"versions.yml"
  content = File.read(file_name)
  File.open(file_name, "w") do |f|
    content.each_line do |line|
      line.chomp!
      if line =~ /\A[a-z]+: [\d\.]+\.(\d+)\z/
        version = $1.to_i
        line.sub!(/#{$1}\z/, (version+1).to_s)
      end
      f.puts line
    end
  end
end
