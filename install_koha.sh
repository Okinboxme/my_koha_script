#!/bin/bash

# Load configuration from the koha_install.config file
source ./koha_install.config

# Update system packages
sudo apt update
sudo apt upgrade -y

# Install Mousepad text editor
sudo apt -y install nano

# Add Koha community repository
sudo sh -c 'wget -qO - https://debian.koha-community.org/koha/gpg.asc | gpg --dearmor -o /usr/share/keyrings/koha-keyring.gpg'
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/koha-keyring.gpg] https://debian.koha-community.org/koha stable main" >> /etc/apt/sources.list.d/koha.list'

# Update package list to include Koha repository
sudo apt update

# Install MariaDB server
sudo apt install -y mariadb-server

# Set the MariaDB root password from the configuration file
sudo mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"

# Install Koha
sudo apt install -y koha-common

# Configure Koha settings (change port number)
sudo mousepad /etc/koha/koha-sites.conf

# Set INTRAPORT value from config
sed -i "s/^INTRAPORT=.*/INTRAPORT=\"$INTRAPORT\"/" /etc/koha/koha-sites.conf

# Enable Apache modules
sudo a2enmod rewrite
sudo a2enmod cgi
sudo service apache2 restart

# Create a Koha instance (using the instance name from the config)
sudo koha-create --create-db "$KOHA_INSTANCE_NAME"

# Configure Apache to listen on additional ports from config
echo "Listen $LISTEN_PORTS" | sudo tee -a /etc/apache2/ports.conf

# Restart Apache
sudo service apache2 restart

# Enable Apache modules and sites for Koha
sudo a2dissite 000-default
sudo a2enmod deflate
sudo a2ensite "$KOHA_INSTANCE_NAME"
sudo service apache2 restart

# Restart Memcached service
sudo service memcached restart

# Extract the MySQL password from the Koha config file
MYSQL_PASSWORD=$(grep -oP '(?<=<mysql_database_password>)[^<]+' /etc/koha/sites/$KOHA_INSTANCE_NAME/koha-conf.xml)

# Inform user to access Koha Staff Client
echo "Installation Complete!"
echo "You can now access Koha Staff Client at http://localhost:$INTRAPORT"
echo "Login with the MySQL username and password from the Koha config file"
echo "MySQL password: $MYSQL_PASSWORD"
echo "Login with the username koha_library and password: $MYSQL_PASSWORD"

# End of script
