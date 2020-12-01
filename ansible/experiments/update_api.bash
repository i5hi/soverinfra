#!/bin/bash -e

cd /home/ishi/api.sats.cc/
git add .
git commit -am "auto update"
git push

cd /home/ishi/infra.sats.cc/ansible/experiments
ansible-playbook  update_api.yaml
