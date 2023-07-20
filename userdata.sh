#!/bin/bash -xe # xtrace and errexit 
# STEP 1 - Setpassword & DB Variables

DBName='example'
DBUser='example'
DBPassword='example'
DBRootPassword='example'

# STEP 2 - Install system software - including Web and DB

sudo yum install -y wget php-mysqlnd httpd php-fpm php-mysqli mariadb105-server php-json php php-devel 

# STEP 3 - Web and DB Servers Online - and set to startup


systemctl enable httpd #manages both system and service configurations, enabling administrators to manage the OS and control the status of services
systemctl enable mariadb #""
systemctl start httpd #""
systemctl start mariadb #""

# STEP 4 - Set Mariadb Root Password

mysqladmin -u root password $DBRootPassword

# STEP 5 - Install Wordpress

wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
tar -zxvf latest.tar.gz #tar it’s used for creating & extracting archive files/zxvf (compress,extracts,verb.,filename)
cp -rvf wordpress/* . #copy (force copy by removing ,verb.,  )
rm -R wordpress #remove
rm latest.tar.gz #remove

# STEP 6 - Configure Wordpress

cp ./wp-config-sample.php ./wp-config.php
sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php #(Stream editor) sed -i 's/old-text/new-text/g' input.txt.
sed -i "s/'username_here'/'$DBUser'/g" wp-config.php #""
sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php #""

# Step 6a - permissions

usermod -a -G apache ec2-user #change the properties of a user in Linux through the command line
chown -R ec2-user:apache /var/www # The chown command allows you to change the user and/or group ownership of a given file, directory, or symbolic link.
chmod 2775 /var/www #used to change the access permissions of files and directories / First, it means that people in your group can create new files in that directory, but other people cannot
find /var/www -type d -exec chmod 2775 {} \; #find / ""
find /var/www -type f -exec chmod 0664 {} \; #find / Chmod 0664 sets permissions so that, (U)ser / owner can read, can write and can't execute. (G)roup can read, can write and can't execute. (O)thers can read, can't write and can't execute.

# STEP 7 Create Wordpress DB

echo "CREATE DATABASE $DBName;" >> /tmp/db.setup #echo is used to display line of text/string that are passed as an argument
echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup #""
echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup #""
echo "FLUSH PRIVILEGES;" >> /tmp/db.setup #""
mysql -u root --password=$DBRootPassword < /tmp/db.setup
sudo rm /tmp/db.setup #sudo -allows you to run programs with the security privileges of another user 
