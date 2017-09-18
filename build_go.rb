name "logjam-go"
version "1.9"
iteration "1"

vendor "skaes@railsexpress.de"

source "https://golang.org/dl/go#{version}.linux-amd64.tar.gz",
       checksum: "d70eadefce8e160638a9a6db97f7192d8463069ab33138893ad3bf31b0650a79"

run "mv", "go", "/usr/local"
run "ln", "-s", "/usr/local/go/bin/go", "/usr/local/bin/go"
run "ln", "-s", "/usr/local/go/bin/godoc", "/usr/local/bin/godoc"
run "ln", "-s", "/usr/local/go/bin/gofmt", "/usr/local/bin/gofmt"
