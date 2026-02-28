#!/usr/bin/bash

# Swich to root user
sudo -i

# Update OS with latest patches
yum update -y

# Install epel repository
yum install epel-release -y

# Install Dependencies
dnf -y install centos-release-rabbitmq-38
dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
systemctl enable --now rabbitmq-server

# Setup access to user test and make it admin
sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
rabbitmqctl add_user test test
rabbitmqctl set_user_tags test administrator
systemctl restart rabbitmq-server


# Starting the firewall and allowing the port 5672 to access rabbitmq
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --add-port=5672/tcp
firewall-cmd --runtime-to-permanent
systemctl start rabbitmq-server
systemctl enable rabbitmq-server
systemctl status rabbitmq-server

echo "rmq01 machine was done"

#End