#!/usr/bin/bash

# Swich to root user
sudo -i

# Install memcached
dnf install memcached -y

# Start & enable memcache on port 11211
systemctl start memcached
systemctl enable memcached
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
systemctl restart memcached

# Starting the firewall and allowing the port 11211 to access memcache
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --add-port=11211/tcp
firewall-cmd --runtime-to-permanent
firewall-cmd --add-port=11111/udp
firewall-cmd --runtime-to-permanent
memcached -p 11211 -U 11111 -u memcached -d

echo "mc01 machine was done"

#End