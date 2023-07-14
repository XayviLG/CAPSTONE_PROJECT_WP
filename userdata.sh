#! /bin/bash

sudo yum update -y
sudo yum install -y httpd php mysql mysql-server
sudo service httpd start
sudo chkconfig httpd on
sudo chmod 777 /var/www
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo chmod 777 /var/www/html

sudo mysql -e "CREATE DATABASE webserver /*\!40100 DEFAULT CHARACTER SET utf8 */;"
sudo mysql -e "CREATE USER Javier@localhost IDENTIFIED BY 'javier2468';"
sudo mysql -e "GRANT ALL PRIVILEGES ON mydb.* TO 'Javier'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

curl -LO https://wordpress.org/latest.zip
sudo mv latest.zip /var/www/html
cd /var/www/html
sudo unzip latest.zip
sudo mv -f wordpress/* ./
sudo service httpd restartyes