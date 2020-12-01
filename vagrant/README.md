# vagrant: a development environment

vagrant leverages the virtualization capabilities of virtualbox/vmware and allows developers to create
custom development environments declared in a Ruby script named *Vagrantfile*.

Sounds awful familiar doesnt' it?

Yes, Docker essentially achieves the same thing; and more; through a different set of technology. 

Vagrant is strictly limited to the development environment, and allows users to maintain consistency in their dev environments as well easily spin up new environments for testing. Although this can be done with a pure-docker setup too, vagrant is a nice way to simulate the host os, inside which you can test your container cluster. 


## install

Vagrant requires a virtualization software, for this example we use virtualbox:

```
wget https://download.virtualbox.org/virtualbox/6.1.16/virtualbox-6.1_6.1.16-140961~Ubuntu~eoan_amd64.deb

dpkg -i virtualbox-6.1_6.1.16-140961~Ubuntu~eoan_amd64.deb -y

wget https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.deb

dpkg -i vagrant_2.2.14_x86_64.deb -y

```
## Vagrantfile

The Vagrantfile is written in Ruby.

```
Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
   config.vm.network "forwarded_port", guest: 8200, host: 8200, protocol: "tcp"

  config.vm.provider :virtualbox do |vb|
	vb.memory = 1024
	vb.cpus = 1
  end
end

```

In this example, we 
- chose the os 
- set up port forwarding so that 8200 in the VM can be accessed at localhost:8200
- setup memory and cpu usage

## Run

In the folder with the Vagrantfile

```
vagrant up
vagrant ssh
```