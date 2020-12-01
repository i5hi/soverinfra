#!/bin/bash

URL=$1

git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
mkdir -p /etc/letsencrypt/live
cd /opt/letsencrypt
sudo -H ./letsencrypt-auto certonly --standalone -d $URL

