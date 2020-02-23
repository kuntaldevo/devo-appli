
** TOOD Out of date **


Window 7

Open a CMD window, Right click to run as Administrator.

## Install Chocolatey

https://chocolatey.org/install#install-with-cmdexe

## Install Git

choco install -y git

## Install Terraform

choco install -y terraform

## Install Packer

choco install -y packer --version 1.1.3 --force

## Install ChefDK

choco install -y chefdk

## Install AWS-SDK

choco install -y awscli

## Configure / Setup SSH

# Switch to Gitbash

## Clone the Repo

git clone git@github.com:Paxata/devops-application.git

## Setup AWS Credentials

 mkdir ~/.aws
 touch ~/.aws/config
 touch ~/.aws/credentials

 notepad.exe ~/.aws/credentials
 notepad.exe ~/.aws/config

~/.aws/config

~/.aws/credentials

This completes installation


Put your credentials into ~/.aws or ~/.azure
