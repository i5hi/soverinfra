#!/bin/bash

sudo apt-get update
sudo apt-get install python-pexpect -y
sudo apt-get install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

