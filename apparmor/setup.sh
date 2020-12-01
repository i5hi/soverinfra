#!/bin/bash

cat /sys/module/apparmor/parameters/enabled
aa-status
ps auxZ | grep -v '^unconfined'

# copy all the app-specific config files

sudo aa-enforce nginx
sudo /etc/init.d/apparmor reload
sudo service nginx restart