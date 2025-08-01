name "logjam-app"
version YAML.load_file(Pathname.new(__dir__)+"versions.yml")["appl"]
vendor "skaes@railsexpress.de"

depends "logjam-tools", ">= 0.21.2"
depends "logjam-passenger", ">= 0.24-1"
depends "logjam-code", "= #{version}"
depends "logrotate"
depends "runit"
depends "adduser"

apt_setup "apt-get update -y && apt-get install apt-transport-https ca-certificates -y"
apt_setup "echo 'deb [trusted=yes] https://railsexpress.de/packages/ubuntu/#{codename} ./' >> /etc/apt/sources.list"
apt_setup "DEBIAN_FRONTEND=noninteractive apt-get install tzdata -y"

add "images/app/etc/apache2/mods-available/passenger.conf", ".passenger.conf"
run "cp", ".passenger.conf", "/etc/apache2/mods-available/passenger.conf"
run "chmod", "644", "/etc/apache2/mods-available/passenger.conf"

add "images/app/etc/apache2/sites-available/logjam.conf", ".logjam.conf"
run "cp", ".logjam.conf", "/etc/apache2/sites-available/logjam.conf"
run "chmod", "644", "/etc/apache2/sites-available/logjam.conf"

add "images/app/etc/logrotate.d/logjam", ".logrotate.conf"
run "cp", ".logrotate.conf", "/etc/logrotate.d/logjam"
run "chmod", "644", "/etc/logrotate.d/logjam"

run "mkdir", "/etc/service/logjam"
add "images/app/etc/service/logjam/run", ".logjam.run"
run "cp", ".logjam.run", "/etc/service/logjam/run"
run "chmod", "755", "/etc/service/logjam/run"

# The next line prevents a buggy docker behavior on arm64 where the
# docker daemon fails to send the closing empty line in a chunked
# transfer encoding of the log stream. fpm-fry attaches to the
# container a sends the log stream to stdout, but whithout the closing
# empty line it will wait forever, preventing successful package
# builds. It seems to be some race condition in the docker
# daemon. This is of course not a reliable fix but I don't see any
# better option.
run "sleep", "1"

files "/etc/apache2/mods-available/passenger.conf"
files "/etc/apache2/sites-available/logjam.conf"
files "/etc/service/logjam/run"
files "/etc/logrotate.d/logjam"

after_install <<-"EOS"
#!/bin/bash
a2enmod expires headers rewrite passenger
a2dissite 000-default
a2ensite logjam

adduser --gecos '' --no-create-home --home /opt/logjam/app --disabled-login --disabled-password logjam
chown logjam:logjam /opt/logjam/app/config.ru
chown -R logjam:logjam /opt/logjam/app/tmp /opt/logjam/app/log

export RAILS_ENV=production
export PATH=/opt/logjam/bin:$PATH
cd /opt/logjam/app
bundle exec whenever --user logjam --update-crontab --roles cron,worker
env LOGJAM_DEVICES="localhost:9606,localhost:9706" bundle exec rake logjam:daemons:install

chown -R logjam:logjam /opt/logjam/
echo logjam post-install completed
EOS
