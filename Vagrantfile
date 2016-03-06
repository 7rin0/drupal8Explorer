# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.6.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	# Vagrant virtual environment (box)
	config.vm.box = "ubuntu/trusty64"

	# Update manually
	config.vm.box_check_update = false

	# The url from where the 'config.vm.box' box will be fetched if it
	# doesn't already exist on the user's system.
	config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/20160209.0.0/providers/virtualbox.box"

	# Create a private network, which allows host-only access to the machine
	# using a specific IP.
	config.vm.network :private_network, ip: "192.168.75.57"

	# The first argument is the path on the host to the actual folder.
	# The second argument is the path on the guest to mount the folder.
	# The optional third argument is a set of non-required options.
	config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", owner: "vagrant", group: "www-data", mount_options: ["dmode=775,fmode=775"]

	config.vm.provider "virtualbox" do |v|
  		v.memory = 1024
	end

	# A script to init out machine's environment
	config.vm.provision :shell, path: "config/install.sh"
	
end
