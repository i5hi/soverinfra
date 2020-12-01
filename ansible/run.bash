#!/bin/bash

# mail requires user to input new IP from terraform in postfix/hostname

cd $HOME/linux20/ansible/playbooks
# # ssh as root for setup
#ansible-playbook init.yaml
#ansible-playbook mail.yaml
# refer to postfix/helper.sh for manual DNS steps and restart mail server


ansible-playbook git.yaml
ansible-playbook blockstorage.yaml
ansible-playbook dependencies.yaml
ansible-playbook sushi.yaml

REPLACE_USER="	User sushi"
sed -i "3s/.*/$REPLACE_USER/" $HOME/.ssh/config
REPLACE_PORT=" Port 22909"
sed -i "4s/.*/$REPLACE_USER/" $HOME/.ssh/config

ansible-playbook app.yaml
echo "\n\n\n*****************************\n!!Get in there and run final!!*****************************\n"
# for now /home/ishi/linux20/final.bash has to be run manually cuz 
# for some reason ansible runs node under sh and ENV varibales arent being captured

