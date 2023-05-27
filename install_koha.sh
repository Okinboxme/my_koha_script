#!/bin/bash

printf "
Powered by:
 ---
   ____            _                  ___               _    _      _   _  __     _             ___           _        _ _           
 / ___| _   _ ___| |_ ___ _ __ ___  / _ \ _ __   ___  | |  | |_ __| | | |/ /___ | |__   __ _  |_ _|_ __  ___| |_ __ _| | | ___ _ __ 
 \___ \| | | / __| __/ _ \ '_ ` _ \| | | | '_ \ / _ \ | |  | __/ _` | | ' // _ \| '_ \ / _` |  | || '_ \/ __| __/ _` | | |/ _ \ '__|
  ___) | |_| \__ \ ||  __/ | | | | | |_| | | | |  __/ | |__| || (_| | | . \ (_) | | | | (_| |  | || | | \__ \ || (_| | | |  __/ |   
 |____/ \__, |___/\__\___|_| |_| |_|\___/|_| |_|\___| |_____\__\__,_| |_|\_\___/|_| |_|\__,_| |___|_| |_|___/\__\__,_|_|_|\___|_|   
        |___/                                                                                                                       
"


#!/bin/bash

#Install script KOHA
sudo wget -q -O- https://debian.koha-community.org/koha/gpg.asc | sudo apt-key add -
echo 'deb http://debian.koha-community.org/koha stable main' | sudo tee /etc/apt/sources.list.d/koha.list
sudo apt-get update
sudo apt-get update && apt upgrade -yq
echo 'deb http://debian.koha-community.org/koha stable main' | sudo tee /etc/apt/sources.list.d/koha.list
sudo apt-get update
sudo dpkg-reconfigure locales;
#dependecy install
sudo apt-get install -y libapache2-mpm-itk
sudo apt-get install -y memcached
sudo apt-get -y install mariadb-server
sudo apt-get install -y koha-common
sudo apt-get install -y multipath-tools
sudo systemctl restart memcached
sudo apt install -y koha-elasticsearch openjdk-11-jdk-headless
sudo apt-get install -y apt-transport-https
sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update && sudo apt-get install -y elasticsearch
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install -y analysis-icu
sudo service elasticsearch restart
#koha basic config
sudo a2enmod deflate
sudo a2dismod mpm_event
sudo a2enmod mpm_itk
sudo a2enmod rewrite
sudo a2enmod cgi
sudo systemctl restart apache2
sudo koha-translate --install pt-PT
sudo cp config/koha-sites.conf /etc/koha/
sudo koha-create --create-db koha
sudo rm /var/www/html/index.html
sudo cp config/ports.conf /etc/apache2/
#Apache config
sudo a2enmod deflate
sudo a2ensite koha
sudo a2dissite 000-default.conf
#restart services
sudo systemctl restart apache2
#Show login data
sh auth.sh
