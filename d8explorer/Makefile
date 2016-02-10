get_requirements:
	sudo apt-get install php5-cli
	curl -s http://getcomposer.org/installer | php; sudo mv composer.phar /usr/local/bin/composer; bash

get_vendors:
	composer install

run_drupal_8:
	nohup php -S 127.0.0.1:7070 &

clear_cache:
	php bin/drush cr

drupal_console_list:
	php bin/dconsole list