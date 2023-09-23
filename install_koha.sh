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

apt-get update
apt-get -y install sudo wget gnupg2
wget -qO - https://debian.koha-community.org/koha/gpg.asc | gpg --dearmor -o /usr/share/keyrings/koha-keyring.gpg
apt-get update -yq
echo 'deb http://debian.koha-community.org/koha oldstable main' | sudo tee /etc/apt/sources.list.d/koha.list
sudo apt-get update

sudo apt-get install koha-common

sudo apt-get install mariadb-server

#Set up Apache
sudo a2enmod rewrite 
sudo a2enmod cgi 
sudo service apache2 restart
#sudo koha-create --create-db libraryname
sudo koha-create --create-db mainlibrary



#Show login data
sh auth.sh
