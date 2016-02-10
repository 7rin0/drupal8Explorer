#!/bin/bash

# No interactive settings
sudo cp -f /vagrant/grub/grub /etc/default/grub
sudo DEBIAN_FRONTEND=noninteractive update-grub -y

# Default variables to no interaction installations
echo mysql-server mysql-server/root_password select root | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again select root | sudo debconf-set-selections

# Update packages
sudo DEBIAN_FRONTEND=noninteractive apt-get -f install -y
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
# sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Install LAMP
sudo DEBIAN_FRONTEND=noninteractive apt-get install apache2 -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install mysql-server -y
sudo apt-get install php5 libapache2-mod-php5 -y
sudo apt-get install php5-mcrypt php5-curl php5-gd php5-cli -y
sudo a2enmod rewrite
sudo /etc/init.d/apache2 restart -y

# Install Environment
sudo DEBIAN_FRONTEND=noninteractive apt-get install git -y
#sudo DEBIAN_FRONTEND=noninteractive apt-get install jenkins -y

# Install D8 App
sudo DEBIAN_FRONTEND=noninteractive apt-get install drush -y

# Create a startup project
cd /var/www && sudo mkdir drupal8explorer && sudo drush dl drupal-8 --destination=./ --drupal-project-rename="abc"

# Run Server

