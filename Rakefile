begin
  require "bundler/setup"
rescue LoadError
  $stderr.puts "Please install bundler"
end

IMAGES = %w(builder tools ruby code passenger demo)
ROOT = File.expand_path("..", __FILE__)

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
  task :test => :build do
    test_image("builder")
  end
end

namespace :tools do
  task :build => "builder:build" do
    build_image("tools")
  end
  task :test => :build do
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
  task :test => :build do
    test_image("ruby")
  end
  task :export => :build do
    run_image("ruby", "tar czf /exports/opt-logjam-ruby.tar.gz /opt/logjam")
  end
end

namespace :code do
  task :build => "builder:build" do
    build_image("code")
  end
  task :test => :build do
    test_image("code")
  end
  task :export => :build do
    run_image("code", "tar czf /exports/opt-logjam-app.tar.gz /opt/logjam/app")
  end
end

namespace :passenger do
  task :build => "builder:build" do
    build_image("passenger")
  end
  task :test => :build do
    test_image("passenger")
  end
  task :export => :build do
    run_image("passenger", "tar czf /exports/opt-logjam-passenger.tar.gz /opt/logjam/bin/passenger* /opt/logjam/lib/ruby/gems/2.2.0/gems/passenger* /opt/logjam/lib/ruby/gems/2.2.0/gems/rack* /opt/logjam/lib/ruby/gems/2.2.0/gems/daemon* /etc/apache2/mods-available/passenger.load")
  end
  task :run do
    system "docker run --rm -it -P --name passenger #{image_name 'passenger'}"
  end
  desc "attach to running demo container"
  task :attach do
    system "docker exec -it passenger bash"
  end
end

namespace :demo do
  desc "build the demo image"
  task :build => "tools:build" do
    build_image("demo")
  end

  task :test => :build do
    test_image("demo")
  end

  desc "run a demo container"
  task :run do
    system "docker run --rm -it -p 80:80 -p 8080:8080 --name demo #{image_name 'demo'}"
  end

  desc "attach to running demo container"
  task :attach do
    system "docker exec -it demo bash"
  end
end

desc "build all images"
task :build => IMAGES.map{|d| "#{d}:build"}

desc "export libraries and ruby"
task :export => %w(ruby:export tools:export code:export)

desc "import libraries and ruby"
task :import do
  system "cp -p exports/*.gz images/demo/"
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
