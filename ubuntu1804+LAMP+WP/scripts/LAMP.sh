#!/bin/bash -eux

#install apache

sudo apt update
sudo apt upgrade -y
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo ufw allow in "Apache Full"
sudo sed -i 's/ index.html index.cgi index.pl index.php/ index.php index.cgi index.pl index.html /' /etc/apache2/mods-enabled/dir.conf
sudo sed -i '$a\<Directory /var/www/html/>' /etc/apache2/apache2.conf
sudo sed -i '$a\    AllowOverride All' /etc/apache2/apache2.conf
sudo sed -i '$a\</Directory>' /etc/apache2/apache2.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

#install PHP

sudo apt install php libapache2-mod-php php-mysql php-cli php-xml -y

#download wordpress

sudo apt install curl -y
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php 
mkdir /tmp/wordpress/wp-content/upgrade
sudo cp -a /tmp/wordpress/. /var/www/html

#wordpress configuration

me=$(whoami)
sudo chown -R $me:www-data /var/www/html
sudo find /var/www/html -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/html/wp-content
sudo chmod -R g+w /var/www/html/wp-content/themes
sudo chmod -R g+w /var/www/html/wp-content/plugins
sudo sed -i 's/database_name_here/wordpress/' /var/www/html/wp-config.php
sudo sed -i 's/username_here/wordpressuser/' /var/www/html/wp-config.php
sudo sed -i 's/password_here/147258369/' /var/www/html/wp-config.php

#install and configuration mysql

sudo apt install mysql-server -y
sudo mysql -u root -p"147258369" -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '147258369'; FLUSH PRIVILEGES; "

# variables for our DB (DB name, username, password).
DBNAME=wordpress
DBUSER=wordpressuser
DBPASS=147258369
# password for root-user mysql.
ROOTPASS=147258369
# variable of directory, where is our DB located
DBDIR=/var/lib/mysql/
# -----------------------------------
# 1 - creating DM for website.
# -----------------------------------
# creating new user.
mysql -u root -p"$ROOTPASS" -e "create user "$DBUSER"@'localhost' identified by '$DBPASS';"
#  creating DB and grant privilegies to user.
mysql -u root -p"$ROOTPASS" -e "create database "$DBNAME"; grant all on "$DBNAME".* to "$DBUSER"@'localhost'; flush privileges;"
sudo systemctl restart apache2
sync
