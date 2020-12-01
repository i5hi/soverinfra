#!/bin/bash -e

cd /home/ishi/api.sats.cc/
git add .
git commit -am "auto update"
git push

cd /home/ishi/soverinfra/ansible/experiments
ansible-playbook  update_api.yaml
