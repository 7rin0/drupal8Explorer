#!/bin/bash

# No interactive settings
sudo cp -f /vagrant/configs/grub /etc/default/grub
sudo update-grub

# Default variables to no interaction installations
echo mysql-server mysql-server/root_password select root | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again select root | sudo debconf-set-selections
sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile

# Update packages
sudo DEBIAN_FRONTEND=noninteractive apt-get -f install -y
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Install LAMP
sudo DEBIAN_FRONTEND=noninteractive apt-get install apache2 -y
sudo cp -f /vagrant/configs/000-default.conf /etc/apache2/sites-available/000-default.conf
sudo sed -i -e '1 i\ ServerName localhost ' /etc/apache2/apache2.conf
sudo DEBIAN_FRONTEND=noninteractive apt-get install mysql-server -y
sudo apt-get install php5 libapache2-mod-php5 -y
sudo apt-get install php5-dev -y
sudo apt-get install php5-mcrypt php5-curl php5-gd php5-cli -y
sudo a2enmod rewrite

# Install Environment
sudo DEBIAN_FRONTEND=noninteractive apt-get install git -y
#sudo DEBIAN_FRONTEND=noninteractive apt-get install jenkins -y
sudo curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/bin/composer
sudo composer config -g github-oauth.github.com f0502ecd3d7c8e7e47223616c177b869180a3e05

# Install cache accelerators and server services
sudo apt-get install php5-memcache memcached php-pear -y
sudo pecl install memcache
echo "extension=memcache.so" | sudo tee /etc/php5/apache2/conf.d/memcache.ini

# Install Drush and Setup a Drupal 8 project
sudo DEBIAN_FRONTEND=noninteractive apt-get install drush -y
sudo drush dl drupal-8 --destination=/var/www --drupal-project-rename="d8sandbox" -y
sudo mysql -u root -proot -h localhost -e'create database d8sandbox'
sudo mkdir -p /var/www/d8sandbox/sites/default/files
sudo mkdir -p /var/www/d8sandbox/sites/default/files/translations
sudo chmod -R 777 /var/www/d8sandbox/sites/default/files
cd /var/www/d8sandbox && sudo composer install --no-interaction --prefer-source
sudo cp -f /vagrant/configs/settings.php /var/www/d8sandbox/sites/default/settings.php
sudo ln -nsf /var/www/d8sandbox ~

# Restart services
sudo /etc/init.d/apache2 restart -y

