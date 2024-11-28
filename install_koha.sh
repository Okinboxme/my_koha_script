#!/bin/bash

# Update system packages
sudo apt update
sudo apt upgrade -y

# Install Mousepad text editor
sudo apt -y install mousepad

# Add Koha community repository
sudo sh -c 'wget -qO - https://debian.koha-community.org/koha/gpg.asc | gpg --dearmor -o /usr/share/keyrings/koha-keyring.gpg'
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/koha-keyring.gpg] https://debian.koha-community.org/koha oldstable main" >> /etc/apt/sources.list.d/koha.list'

# Update package list to include Koha repository
sudo apt update

# Install MariaDB server
sudo apt install -y mariadb-server

# Set the MariaDB root password (replace 'newpass' with your desired password)
sudo mysqladmin -u root password 'newpass'

# Install Koha
sudo apt install -y koha-common

# Configure Koha settings (change port number)
sudo mousepad /etc/koha/koha-sites.conf

# Edit the INTRAPORT to 8080 (staff client port)
echo 'Please change INTRAPORT="8080" in /etc/koha/koha-sites.conf manually'

# Enable Apache modules
sudo a2enmod rewrite
sudo a2enmod cgi
sudo service apache2 restart

# Create a Koha instance (replace "library" with your desired instance name)
sudo koha-create --create-db library

# Open Apache ports for Koha (8080 for staff client)
sudo mousepad /etc/apache2/ports.conf
echo 'Please add Listen 8080 under "Listen 80" in /etc/apache2/ports.conf manually'

# Restart Apache
sudo service apache2 restart

# Enable Apache modules and sites for Koha
sudo a2dissite 000-default
sudo a2enmod deflate
sudo a2ensite library
sudo service apache2 restart

# Restart Memcached service
sudo service memcached restart

# Inform user to access Koha Staff Client
echo "Installation Complete!"
echo "You can now access Koha Staff Client at http://localhost:8080"
echo "Login with the MySQL username and password from /etc/koha/sites/library/koha-conf.xml"

# End of script
