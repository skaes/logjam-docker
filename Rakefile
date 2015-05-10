begin
  require "bundler/setup"
rescue LoadError
  $stderr.puts "Please install bundler"
end
require "ansi"

ROOT = File.expand_path("..", __FILE__)

def system(cmd)
  puts ANSI.green{cmd}
  Kernel.system cmd
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

def build_image(name)
  Dir.chdir(image_dir(name)) do
    system "docker build -t=#{image_name(name)} ."
  end
end

def test_image(name)
  system "docker run --rm -it -P #{image_name(name)} /bin/bash -l"
end

def run_image(name, arg)
  system "docker run --rm -it -v #{export_dir}:/exports #{image_name(name)} /bin/bash -l -c '#{arg}'"
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
    system "docker run --rm -it -h logjam.local -p 80:80 -p 8080:8080 --link logjamdb:logjamdb --link memcache:logjamcache --name logjam #{image_name 'app'}"
  end

  desc "attach to running app container"
  task :attach do
    system "docker exec -it logjam bash"
  end
end

namespace :demo do
  desc "build the demo image"
  task :build => "app:build" do
    build_image("demo")
  end

  task :test do
    test_image("demo")
  end

  desc "run a demo container"
  task :run do
    system "docker run --rm -it -p 80:80 -p 8080:8080 -p 9605:9605 --name demo -h demo.local #{image_name 'demo'}"
  end

  desc "attach to running demo container"
  task :attach do
    system "docker exec -it demo bash"
  end
end

namespace :develop do
  desc "copy build scripts"
  task :scripts do
    system "tar cp `find images -type f | egrep -v 'Dockerfile|develop|demo|.tar.gz'` | tar xpf - -C images/develop --strip-components 2"
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
    system "docker run --rm -it -p 80:80 -p 8080:8080 -p 9605:9605 --link logjamdb:logjamdb --link memcache:logjamcache --name develop -h develop.local #{image_name 'develop'}"
  end

  desc "attach to running develop container"
  task :attach do
    system "docker exec -it develop bash"
  end
end

namespace :logjamdb do
  desc "start a logjamdb instance"
  task :run do
    system "docker run -d -P --name logjamdb mongo:3.0.2"
  end
end

namespace :memcache do
  desc "start a memcached instance"
  task :run do
    system "docker run -d -P --name memcache memcached:1.4.24"
  end
end

desc "build all end user images"
task :runnables => %w[app:build demo:build develop:build]

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

task :run => "demo:run"
task :default => :build

desc "upload images to registry"
task :upload do
  system "docker push stkaes/logjam-app"
  system "docker push stkaes/logjam-demo"
end
