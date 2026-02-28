# Multi-Tier-Automated-Infrastructure-with-Vagrant
This project demonstrates the automated deployment of a multi-tier web application stack using Vagrant and VirtualBox. The environment consists of five specialized Virtual Machines, each provisioned via shell scripts to handle a specific layer of the application architecture.


# Architecture Overview
The infrastructure is designed to separate concerns across five distinct nodes, ensuring scalability and isolation. All nodes run on CentOS Stream 9, with the exception of the Web Server which utilizes Ubuntu 22.04 (Jammy).

Hostname     Service                      OS              IP Address            RAM
web01        Nginx (Load Balancer)        Ubuntu22.04     192.168.56.11         1024 MB
app01        Tomcat (App Server)          CentOS9         192.168.56.12         2048 MB
rmq01        RabbitMQ (Broker)            CentOS 9        192.168.56.13         1024 MB
mc01         Memcached (Caching)          CentOS 9        192.168.56.14         1024 MB
db01         MariaDB (Database)           CentOS 9        192.168.56.15         1024 MB


# Features
Infrastructure as Code (IaC): Entire stack defined in a single Vagrantfile.

Automated Provisioning: Custom shell scripts handle the installation, configuration, and service management for each node.

Automated Host Management: Uses the vagrant-hostmanager plugin to ensure VMs can communicate via hostnames instead of just IPs.

Private Networking: Secure internal communication between services on the 192.168.56.0/24 subnet.

# Prerequisites
Before you begin, ensure you have the following installed:

1- VirtualBox

2- Vagrant

3- Vagrant Hostmanager Plugin:
   vagrant plugin install vagrant-hostmanager


# Installation & Deployment
1- Clone the repository:
   git clone https://github.com/MinaMofeed/Multi-Tier-Automated-Infrastructure-with-Vagrant.git
   cd your-repo-name
2- Spin up the environment:
This command will download the boxes and trigger the shell scripts automatically:
  vagrant up
3- Verify the setup:
You can SSH into any machine to check the service status:
  vagrant ssh web01
  systemctl status nginx


# Project Structure
├── Vagrantfile            # Infrastructure definition (VM specs, Networking)
├── scripts/               # Automated provisioning logic
│   ├── db01.sh            # MariaDB setup and schema migration
│   ├── mc01.sh            # Caching layer configuration
│   ├── rmq01.sh           # Message broker setup
│   ├── app01.sh           # Java environment and App deployment
│   └── web01.sh           # Reverse proxy and LB configuration
└── README.md


# Skills Demonstrated
- Linux Administration: Managing different distributions (RHEL-based and Debian-based).

- Network Orchestration: Configuring private networks and host resolution.

- Bash Scripting: Writing idempotent scripts for software installation.

- Resource Management: Allocating CPU/RAM based on service requirements.


# Contact
Created by Mina Mofeed
Linkedin: https://www.linkedin.com/in/mina-mofeed-513376276/
GitHub: https://github.com/MinaMofeed
