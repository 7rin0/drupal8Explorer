#!/bin/bash

# No interactive settings
sudo cp -f /vagrant/configs/grub /etc/default/grub
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

# Install Environment
sudo DEBIAN_FRONTEND=noninteractive apt-get install git -y
#sudo DEBIAN_FRONTEND=noninteractive apt-get install jenkins -y

# Install D8 App
sudo DEBIAN_FRONTEND=noninteractive apt-get install drush -y
sudo cp -f /vagrant/configs/000-default.conf /etc/apache2/sites-available/000-default.conf
sudo mysql -u root -proot -h localhost -e'create database d8sandbox'
sudo curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/bin/composer
cd /var/www/drupal8 && sudo composer install --no-interaction
# sudo drush dl drupal-8 --destination=/var/www --drupal-project-rename="autoInstall"

# Restart services
sudo sed -i -e '1iServerName localhost\' /etc/apache2/apache2.conf
sudo /etc/init.d/apache2 restart -y

