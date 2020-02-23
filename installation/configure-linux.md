# Configuring a Linux system ( ubuntu) for infrastructure.

** TOOD Out of date **


# Install Git

See:  https://git-scm.com/download/linux

```
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git
```

# Install Terraform

See:  https://www.terraform.io/downloads.html

Installation Script is in tooling/install-terraform.sh
   from:  https://github.com/robertpeteuil/terraform-installer

Manual Install
```
sudo apt-get install unzip
Download latest version of the terraform
   example:  wget https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip
unzip terraform_0.11.1_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

# Install Packer

See:  https://www.packer.io/downloads.html

Installation Script is in tooling/install-packer.sh
   from:  https://github.com/robertpeteuil/packer-installer

# Install GetOpt

> sudo apt-get install util-linux

MacOS Note:  Don't forget to:  

```
If you need to have this software first in your PATH run:
  echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' } ~/.bash_profile
```
# Install JQ

> sudo apt-get install jq

# Install OathTool

> sudo apt-get install oathtool

Then use a new Shell

# Install AWS-SDK CLI

> pip install awscli --upgrade --user

# Install Azure CLI

See:  https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest

# Get the application

>  wget https://github.com/Paxata/devops-application/archive/master.zip

OR

NOTE: Ask to have your public key added to the project's Deploy Keys

> git clone git@github.com:Paxata/devops-application.git

# Add AWS MFA credentialing

See:  https://paxata.atlassian.net/wiki/spaces/OPS/pages/381747350/Scripting+the+AWS+MFA+Provisioning
