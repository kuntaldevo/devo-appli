
# Provision

Contains the scripts, playbook, recipes, etc of any used provisioners.

For initial provisioning, a 'raw' VMI is started and the shell provisioner performs some basic updates and modifications.  The goal is to bring the instance's packages up to date as well as install Ansible and everything else that is required for Ansible to run.  After this stage, any additional updates to the VMIs will be completed via Ansible.

## Provisioning Specific Distributions

For a specified Distribution, there is a 'provision' folder that contains Ansible group and host variables. Build versions are specified there.


## Updating Java Keystore (JKS) for paxata.ninja

the certs are stored in Github in ansible/vault location.

Someday Going to add a script to build a fresh JKS for paxata ninja from scratch using the contents of ansible

For now, I just did this, where I got a file from Digicert's Website and followed their directions to update the existing JKS with the new files that contains the keys etc.

https://paxata.atlassian.net/wiki/spaces/OPS/pages/694091841/Create+Java+Key+Store+for+Paxata+Ninja

# Begin notes of other things to create a script some Someday


/Users/gregory.bonk/workspace/devops-application/provision/ansible/roles/install-paxata-certificates/tasks

aws s3 cp s3://paxata-secrets/digicert-secret .

# Create the keystore File and Install the cert
keytool -keystore star_paxata_ninja.jks -import -trustcacerts -alias server -file star_paxata_ninja.crt

# Install the Trust Store Chain
keytool -keystore star_paxata_ninja.jks -import -trustcacerts -alias digicert_ca -file DigiCertCA.crt


openssl pkcs12 -export -name server -in star_paxata_ninja.crt -inkey star_paxata_ninja.key -out star-paxata-ninja.p12


keytool -import -trustcacerts -alias server -file star_paxata_ninja.p7b -keystore star_paxata_ninja.jks


# Debugging AMI Provisioners

There are some Ansible Roles, ones that end in 'provisioner' that are installed when the AMI is packaged but don't run until the AMI is started.


# Cloud Init

Log:  cat /var/log/cloud-init.log

Scripts:  /var/lib/cloud/scripts/

Sub Folders like /var/lib/cloud/scripts/per-instance

# Growpart

is located at `/etc/cloud/cloud.cfg.d/`
