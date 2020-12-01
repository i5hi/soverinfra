#!/bin/bash

#get
curl -L https://toolbelt.treasuredata.com/sh/install-debian-stretch-td-agent3.sh | sh

# start td daemon

sudo /etc/init.d/td-agent start
sudo /etc/init.d/td-agent restart
sudo /etc/init.d/td-agent status

# start up script
sudo nano /etc/init.d/td-agent
# test, by default fluentd takes data from http and routes them to stdout
curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test

# configure
sudo nano /etc/td-agent/td-agent.conf

# to setup rsyslog with fluentd 

sudo nano /etc/rsyslogd.conf
# OR
sudo nano /etc/rsyslog.conf

#ossec setup instructions

# configure ossec.conf to output json as specified in ossec/notes
# use a td-agent owned folder to drop ossec log pos files for in_tail
sudo mkdir /var/log/td-agent
sudo chown td-agent /var/log/td-agent
sudo chmod -R 700 tdagent

# create a group for td-agent to allow access to /var/log
sudo usermod -a -G td-agent debian
sudo usermod -a -G ossec debian

# Change the td-agent start up script to run as debian user
sudo nano /etc/init.d/td-agent

sudo chmod -R 770 /var/ossec/logs/

#make user=debian
#add debian to ossec group

# install ruby and gem for mongo output plugin
sudo apt-get install ruby-full
# the following might also need sudo
gem install fluentd --no-ri --no-rdoc
fluent-gem install fluent-plugin-mongo

# set gem path in /etc/init.d/td-agent

# TD_AGENT_OPTIONS="--gem-path=/opt/td-agent/embedded/lib/ruby/gems/2.4.0/gems"


#
#
#
# !!!! IMPORTANT @@@@##
#
#
#
# Currently gem run is providing a more stable connection to mongodb
# Use the following

sudo apt-get install ruby-full
# sort permissions and make these happen without root
gem install fluentd --no-ri --no-rdoc
fluent-gem install fluent-plugin-mongo

fluentd --setup ./fluent
fluentd -c ./fluent/fluent.conf -vv 


## DOCKER
# Create project directory.
mkdir custom-fluentd
cd custom-fluentd

# Download default fluent.conf and entrypoint.sh. This file will be copied to the new image.
# VERSION is v1.7 like fluentd version and OS is alpine or debian.
# Full example is https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/v1.10/debian/fluent.conf

# curl https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/VERSION/OS/fluent.conf > fluent.conf

curl https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/v1.10-1/edge/fluent.conf > fluent.conf


#curl https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/VERSION/OS/entrypoint.sh > entrypoint.sh

curl https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/v1.10-1/edge/entrypoint.sh > entrypoint.sh

# Create plugins directory. plugins scripts put here will be copied to the new image.
mkdir plugins

# curl https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/Dockerfile.sample > Dockerfile

curl https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/Dockerfile.sample > Dockerfile
