#!/bin/bash -eux

sudo apt update
sudo apt upgrade
sudo apt install nginx
sudo apt install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 2222
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 6000:6003/tcp
sudo ufw allow 6000:6003/udp
sudo ufw enable
sudo ufw status
sudo ufw allow 'Nginx HTTP'
sudo add-apt-repository universe
sudo apt install php-fpm php-mysql
sudo nano /etc/nginx/sites-available/wordpress
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx

sudo apt install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
sudo systemctl restart php7.2-fpm


#download wordpress

sudo apt install curl -y
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php 
mkdir /tmp/wordpress/wp-content/upgrade
sudo cp -a /tmp/wordpress/. /var/www/wordpress

#wordpress configuration

me=$(whoami)
sudo chown -R $me:www-data /var/www/wordpress
sudo find /var/www/wordpress -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/wordpress/wp-content
sudo chmod -R g+w /var/www/wordpress/wp-content/themes
sudo chmod -R g+w /var/www/wordpress/wp-content/plugins
sudo sed -i 's/database_name_here/wordpress/' /var/www/wordpress/wp-config.php
sudo sed -i 's/username_here/wordpressuser/' /var/www/wordpress/wp-config.php
sudo sed -i 's/password_here/147258369/' /var/www/wordpress/wp-config.php

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
sudo systemctl reload nginx
sync
