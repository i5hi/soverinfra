#!/bin/bash

#INSTALL ELASTICSEARCH

sudo apt update
sudo apt install apt-transport-https

sudo apt install openjk-8-jdk

java -version

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'

sudo apt update

sudo apt install elasticsearch

sudo systemctl enable elasticsearch.service

sudo systemctl start elasticsearch.service

curl -X GET "localhost:9200/"

sudo journalctl -u elasticsearch

# INSTALL KIBANA

wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.zip

unzip kibana-3.1.0.zip

sudo apt-get update && sudo apt-get install kibana

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo systemctl start kibana.service
# INSTALL FLUENTD

#install NTP to sync timeservers

#increase the number of file descriptors i.e. the number of files that can be open at once

ulimit -n

#must be more than 1024
nano /etc/security/limits.conf
#ADD
#root soft nofile 65536
#root hard nofile 65536
#* soft nofile 65536
#* hard nofile 65536

curl -L https://toolbelt.treasuredata.com/sh/install-debian-stretch-td-agent3.sh | sh

sudo systemctl start td-agent.service
sudo systemctl status td-agent.service

sudo /usr/sbin/td-agent-gem install fluent-plugin-secure-forward
sudo /usr/sbin/td-agent-gem install fluent-plugin-elasticsearch
#edit /etc/td-agent/td-agent.conf; see help
sudo service td-agent restart

#make sure to allow user td-agent to write to destination folders
chown td-agent path/to/folder/or/file