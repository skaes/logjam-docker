name "logjam-app"
version "0.1"
iteration "5"

vendor "skaes@railsexpress.de"

depends "logjam-tools"
depends "logjam-ruby"
depends "logjam-passenger"
depends "logjam-code"
depends "apache2"
depends "apache2-mpm-worker"
depends "logrotate"
depends "runit"
depends "adduser"

before_build "echo 'deb [trusted=yes] http://railsexpress.de/packages/ubuntu/trusty ./' >> /etc/apt/sources.list"

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
chown logjam.logjam /opt/logjam/app/config.ru
chown -R logjam.logjam /opt/logjam/app/tmp /opt/logjam/app/log

export RAILS_ENV=production
export PATH=/opt/logjam/bin:$PATH
cd /opt/logjam/app
bundle exec whenever --user logjam --update-crontab --roles cron,worker
bundle exec rake logjam:daemons:install

chown -R logjam.logjam /opt/logjam/app/service
echo logjam post-install completed
EOS
