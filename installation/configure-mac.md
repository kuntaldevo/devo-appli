
# Bootstrapping installation

The plan is to install Ansible on a fresh MacOS, and then run ansible to install the rest of the requirements.

# Bootstrapping Ansible

Reference: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-on-macos

`The preferred way to install Ansible on a Mac is via pip.`

Reference:  https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-pip

You need to make sure you have pip installed.

### To Get the latest Pip

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

sudo python get-pip.py

Run:   sudo easy_install pip

Then install Ansible via Pip as recommended. Version supported is 2.6.x

Run:   sudo pip install ansible~=2.6.0

Note:  If the command-line developer tools have not been installed yet a window will popup asking you to install them.  Please approve and follow the directions for the installation.

Note:  You can ignore any warnings like 'The directory {snip} or its parent directory is not owned by the current user and the cache has been disabled.'

# Configure Ansible

In your home directory create an `.ansible.cfg`

Enter the following

```[localhost]
127.0.0.1  ansible_connection=local
```

or in one line,

Run:  echo -e "[localhost]\n127.0.0.1  ansible_connection=local" > ~/.ansible.cfg

# Begin Installation

Open a terminal window, and make sure your current directory is where you want the project folder to go.

Run the following ```ansible-pull -U https://paxata-ansible:41w832TgnKL8aWF@github.com/Paxata/devops-application.git -d `pwd`/devops-application installation/installation-playbook.yml```

NOTE:  Brew might prompt you for your password

# Finishing Up

To begin to use the Provisioning or Infrastructure, you will need to open a fresh shell window.

## IF A Developer

You will still need to setup SAM2AWS.  If not already, please check with Devops to verify your access has been configured.

See [Using SAML2AWS](../saml2aws.md)

## IF A Devops

You will still need to add your AWS credentials and setup for AWS MFA.  See [Using AWS MFA](../aws-mfa.md)

You will need to get any AWS Keypairs from LastPass and copy them into ~/.ssh

# Manual Install

## Install Brew

> http://brew.sh

# Install AWS-SDK

> brew install awscli

## Install Git

> brew install Git

## Install JQ

> brew install jq

## Install Terraform

> brew instal terraform

## Install SAML2AWS

> brew tap versent/homebrew-taps

> brew install saml2aws

## Install the Kubernetes CLI

> brew install kubernetes-cli

# Install GetOpt

> brew install gnu-getopt

# Install oathtool

> brew install oath-toolkit

Note:  Make sure that the proper getopt is in your path  

```
If you need to have this software first in your PATH run:
  echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.bash_profile
```
# For Provisioning EC2 Servers

## Install Packer

Note: Packer is optional if you will never be creating AMIs or Containers

> brew install packer

## Close and open a new shell for the setting to take effect
