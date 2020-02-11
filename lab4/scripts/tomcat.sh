#!/bin/bash -eux

sudo apt update
sudo apt install openjdk-8-jdk openjdk-8-jre -y
sudo groupadd tomcat 
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /tmp
curl -O http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-9/v9.0.30/bin/apache-tomcat-9.0.30.tar.gz
sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf



sudo chown -R tomcat webapps/ work/ temp/ logs/
sudo update-java-alternatives -l
wget https://raw.githubusercontent.com/SadovnichiyDmitry/LAMP-WP-vagrant-box/develop/lab4/CONFIGS/tomcat.service
sudo nano /etc/systemd/system/tomcat.service
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl status
sudo systemctl daemon-reload tomcat
sudo systemctl enable tomcat
wget https://raw.githubusercontent.com/SadovnichiyDmitry/LAMP-WP-vagrant-box/develop/lab4/CONFIGS/tomcat-users.xml
sudo nano /opt/tomcat/conf/tomcat-users.xml
wget https://raw.githubusercontent.com/SadovnichiyDmitry/LAMP-WP-vagrant-box/develop/lab4/CONFIGS/context.xml
sudo cp context.xml /opt/tomcat/webapps/manager/META-INF/context.xml
#sudo nano /opt/tomcat/webapps/manager/META-INF/context.xml
sudo cp context.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml
#sudo nano /opt/tomcat/webapps/host-manager/META-INF/context.xml

sudo wget http://mirrors.jenkins.io/war/latest/jenkins.war
sudo mv jenkins.war /opt/tomcat/webapps/

sudo chown -R tomcat:tomcat /opt/tomcat
sudo chmod -R g+r /opt/tomcat/conf

sudo chmod -R g+w /opt/tomcat/logs
sudo chmod -R g+w /opt/tomcat/temp
sudo chmod -R g+w /opt/tomcat/webapps
sudo chmod -R g+w /opt/tomcat/work

sudo chmod -R g+s /opt/tomcat/conf
sudo chmod -R g+s /opt/tomcat/logs
sudo chmod -R g+s /opt/tomcat/temp
sudo chmod -R g+s /opt/tomcat/webapps
sudo chmod -R g+s /opt/tomcat/work

#usermod -a -G tomcat vagrant
