#!/bin/bash

sudo cp -f /vagrant/grub/grub /etc/default/grub
sudo update-grub

# Default variables to no interaction installations
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

# Update packages
sudo apt-get -f install -y
sudo apt-get update -y && sudo apt-get upgrade -y

# Install LAMP
sudo apt-get install apache2 -y
sudo apt-get install mysql-server -y
sudo apt-get install php5 libapache2-mod-php5 -y
sudo /etc/init.d/apache2 restart -y

# Install D8 App
sudo apt-get install drush -y

# Run Server

