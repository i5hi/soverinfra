#!/bin/bash

# mail requires user to input new IP from terraform in postfix/hostname

cd $HOME/infra.sats.cc/ansible/playbooks
# # ssh as root for setup
ansible-playbook init.yaml
#ansible-playbook mail.yaml
# refer to postfix/helper.sh for manual DNS steps and restart mail server

