#!/bin/bash

wget https://download.virtualbox.org/virtualbox/6.1.16/virtualbox-6.1_6.1.16-140961~Ubuntu~eoan_amd64.deb

dpkg -i virtualbox-6.1_6.1.16-140961~Ubuntu~eoan_amd64.deb -y

wget https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.deb

dpkg -i vagrant_2.2.14_x86_64.deb -y