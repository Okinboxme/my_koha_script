#!/bin/bash

#Install script KOHA
sudo wget -q -O- https://debian.koha-community.org/koha/gpg.asc | sudo apt-key add -
echo 'deb http://debian.koha-community.org/koha oldstable main' | sudo tee /etc/apt/sources.list.d/koha.list
sudo apt-get update
sudo apt-get update && apt upgrade -yq

#sudo apt-get update

sudo apt-get -y install mariadb-server
sudo apt-get install -y koha-common

#copy configuration from koha-sites
sudo cp config/koha-sites.conf /etc/koha/
sudo koha-create --create-db mainlibrary
sudo rm /var/www/html/index.html
sudo cp config/ports.conf /etc/apache2/

#Setup plack
sudo a2enmod headers proxy_http 
#then:
sudo koha-plack --enable mainlibrary
sudo koha-plack --start mainlibrary
sudo service apache2 restart

#Apache config
sudo a2enmod rewrite 
sudo a2enmod cgi 


#restart services
sudo service apache2 restart
#Show login data
sh auth.sh

