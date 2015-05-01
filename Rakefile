begin
  require "bundler/setup"
rescue LoadError
  $stderr.puts "Please install bundler"
end

namespace :demo do
  desc "build the demo image"
  task :build do
    demo_dir = File.expand_path('../images/demo', __FILE__)
    Dir.chdir(demo_dir) do
      system "docker build -t=stkaes/logjamdemo ."
    end
  end

  desc "run a demo container"
  task :run do
    system "docker run --rm -i -t -p 3000:3000 -p 8080:8080 --name logjam stkaes/logjamdemo"
  end
end

desc "build all images"
task :build => 'demo:build'

task :default => 'demo:run'
