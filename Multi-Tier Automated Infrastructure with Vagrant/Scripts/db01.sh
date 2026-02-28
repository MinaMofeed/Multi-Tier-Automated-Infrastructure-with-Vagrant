#!/usr/bin/bash

# Swich to root user
echo "Swiching to root user"
sudo -i

# Install packages
echo "Installing packeges"
yum install expect git mariadb-server -y

# Start and enable mariadb
echo "Start and enable mariadb"
systemctl start mariadb
systemctl enable mariadb

# Run mysql_secure_installation
echo "Runing mysql_secure_installation"
expect <<Eof
spawn mysql_secure_installation
expect "Enter current password for root (enter for none):"
send "\r"
expect "Switch to unix_socket authentication [Y/n]"
send "y\r"
expect "Change the root password? [Y/n]"
send "y\r"
expect "New password:"
send "admin123\r"
expect "Re-enter new password:"
send "admin123\r"
expect "Remove anonymous users? [Y/n]"
send "y\r"
expect "Disallow root login remotely? [Y/n]"
send "y\r"
expect "Remove test database and access to it? [Y/n]"
send "y\r"
expect "Reload privilege tables now? [Y/n]"
send "y\r" 
Eof

# Configering mariadb
echo "Configer mariadb"
mysql -u root -padmin123 <<mysql_script
create database accounts ;
grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123' ;
FLUSH PRIVILEGES ;
mysql_script

# Downloading surce code and initialize database
echo "Downloading surce code and initialize database"
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql

# Restarting mariadb
echo "Restarting mariadb"
systemctl restart mariadb

# Starting the firewall and allowing the mariadb to access from port no. 3306
# systemctl start firewalld
# systemctl enable firewalld
# firewall-cmd --get-active-zones
# firewall-cmd --zone=public --add-port=3306/tcp --permanent
# firewall-cmd --reload
# systemctl restart mariadb

echo "db01 machine was done"

# End
