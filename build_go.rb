name "logjam-go"
version "1.11.2"
iteration "1"

vendor "skaes@railsexpress.de"

source "https://golang.org/dl/go#{version}.linux-amd64.tar.gz",
       checksum: "1dfe664fa3d8ad714bbd15a36627992effd150ddabd7523931f077b3926d736d"

run "mv", "go", "/usr/local"
run "ln", "-s", "/usr/local/go/bin/go", "/usr/local/bin/go"
run "ln", "-s", "/usr/local/go/bin/godoc", "/usr/local/bin/godoc"
run "ln", "-s", "/usr/local/go/bin/gofmt", "/usr/local/bin/gofmt"
