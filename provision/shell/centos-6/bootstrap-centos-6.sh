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

# Patch the server
sudo yum -y upgrade

# Add a public RPM repo for Python to get Pip
sudo yum -y install https://centos6.iuscommunity.org/ius-release.rpm
sudo yum -y install python-pip

# I get an old version of pip and setuptools, so update those
# Pip 9.0.3 last to support python 2.6
sudo pip install --upgrade pip~=9.0.3
sudo pip install --upgrade setuptools

# Ansible and any Repository Management seems to need this
sudo yum -y install libselinux-python

# Cryptography, in the documentation says to install the following.  It was failing before adding these
sudo yum -y install libffi-devel python-devel openssl-devel gcc


# Install Python packages via Pip for ansible.  I got this list from installing Ansible on Python 2.7 which knows how to download and install properly apparetly
# These are in the order that ansible did it when I tried on 2.7

sudo pip install pycparser==2.18
sudo pip install cffi
sudo pip install jinja2
sudo pip install paramiko
sudo pip install pyasn1
sudo pip install bcrypt
sudo pip install cryptography
sudo pip install pynacl==1.0.1
sudo pip install PyYAML
sudo pip install MarkupSafe
sudo pip install six
sudo pip install enum34
sudo pip install idna
sudo pip install asn1crypto
sudo pip install ipaddress

# Install additional python libs that ansible will want
# Required for 'json_query' filter
sudo pip install jmespath

# Add the Ansible repostiory and install Ansible
sudo pip install ansible~=2.6.3

# Debugging Cloud init . Delete the logs so we can see what happens on 'first boot'
sudo rm -rf /var/log/cloud-*.log
