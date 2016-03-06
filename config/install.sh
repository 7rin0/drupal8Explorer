#!/bin/bash

# No interactive settings
sudo cp -f /vagrant/config/machine/grub /etc/default/grub
sudo update-grub

# Default variables to no interaction installations
echo mysql-server mysql-server/root_password select root | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again select root | sudo debconf-set-selections
sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile

# Update packages
sudo DEBIAN_FRONTEND=noninteractive apt-get -f install -y
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Install LAMP
sudo DEBIAN_FRONTEND=noninteractive apt-get install apache2 -y
sudo sed -i -e '1 i\ ServerName localhost ' /etc/apache2/apache2.conf
sudo DEBIAN_FRONTEND=noninteractive apt-get install mysql-server -y
sudo apt-get install php5 -y
sudo apt-get install php5 libapache2-mod-php5 -y
sudo apt-get install php5-dev -y
sudo apt-get install php5-mcrypt -y
sudo apt-get install php5-curl -y
sudo apt-get install php5-gd -y
sudo apt-get install php5-cli -y
sudo apt-get install php5-mysql -y
sudo apt-get install pdo-mysql -y
sudo a2enmod rewrite
sudo service apache2 restart -y

# Prepare Environment
sudo apt-get install zip -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install git -y
sudo curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/bin/composer
sudo composer config -g github-oauth.github.com f0502ecd3d7c8e7e47223616c177b869180a3e05

# Install cache accelerators and server services
sudo apt-get install php5-memcache memcached php-pear -y
sudo pecl install memcache
echo "extension=memcache.so" | sudo tee /etc/php5/apache2/conf.d/memcache.ini

### Project Auto Installer ###
## Add all possible hosts to machine to avoid duplications
sudo cat /vagrant/config/hosts/hosts >> /etc/hosts

# Install Drupal 8
. /vagrant/app/drupal/8/config/requirements.sh

# Restart services
sudo /etc/init.d/apache2 restart -y
