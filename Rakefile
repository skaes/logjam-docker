desc "build docker image"
task :build do
  system "docker build -t=stkaes/logjamdemo ."
end

desc "run the docker container"
task :run do
  system "docker run --rm -i -t -p 3000:3000 -p 8080:8080 --name logjam stkaes/logjamdemo"
end
