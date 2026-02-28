#!/usr/bin/bash

# Swich to root user
sudo -i

# Update OS with latest patches
apt update
apt upgrade

# Install nginx
apt install nginx -y

# Create Nginx conf file
cat <<EOf > /etc/nginx/sites-available/vproapp
upstream vproapp {
server app01:8080;
}
server {
listen 80;
location / {
proxy_pass http://vproapp;
}
}
EOf

# Remove default nginx conf
rm -rf /etc/nginx/sites-enabled/default


# Create link to activate website
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

# Restart Nginx
systemctl restart nginx

echo "web01 machine was done"

#End