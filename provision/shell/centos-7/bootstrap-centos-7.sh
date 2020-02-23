#!/usr/bin/env bash
# B A S H

# Take a fresh, completely raw Centos 6.8 installation and prepare it for Ansible Provisioning
# Once this script completes then all other changes etc shoud be, MUST BE, via Ansible

# Some images (Azure) will come with Open Java JDKs already installed and will partially block the installation
# of the Java we want later. Run Yum to remove and JDK6 & 7
sudo yum -y remove java-1.6.0-openjdk
sudo yum -y remove java-1.7.0-openjdk


# Create hosts file for Ansible, we use this because we do all ansible stand alone
#  Note: the echo must be a single line
sudo mkdir /etc/ansible
sudo sh -c "echo 'localhost ansible_connection=local'  > /etc/ansible/hosts"
sudo sh -c "echo -e '[defaults]\nlog_path=/var/log/ansible.log'  > /etc/ansible/ansible.cfg"

# Patch the server
sudo yum -y upgrade

# Add a public RPM repo for Python to get Pip
sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm
sudo yum -y install python-pip

# Cryptography, in the documentation says to install the following.  It was failing before adding these
sudo yum -y install libffi-devel python-devel openssl-devel gcc

# Install additional python libs that ansible will want
# Required for 'json_query' filter
sudo pip install jmespath

# Add the Ansible repostiory and install Ansible
sudo pip install ansible~=2.9.1

# Debugging Cloud init . Delete the logs so we can see what happens on 'first boot'
sudo rm -rf /var/log/cloud-*.log
