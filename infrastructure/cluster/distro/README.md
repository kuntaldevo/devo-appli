

# Distro

Contains subfolders that identify the "Distribution Id".  Typical configuration will name the folders as the version of Paxata that is being packaged and distributed.

The Distro folder is further broken down

## Distro / ${Distro-id} / Package

Further broken down by the cloud provider's region, this folder contains a '${region-id}.config' file.  This file identifies the Root & Base AMI/VMI that are available be used for packaging the images.

### ROOT_VMI

The VMI to use to create the Base VMI. This is the AMI that is in the amazon marketplace.  
To get this AMI Id, create an instance using the Marketplace configuration. Then look at the instance's description tab and the AMI value in parentheses.

### BASE_VMI

The AMI that is an exact copy of the ROOT AMI that was created as a copy from the AWS marketplace.
To generate the BASE_VMI, run package base-vmi.  Update the BASE_VMI variable with the AMI id returned by packer on successful completion

### BASE_SERVER_AMI

The AMI that is used for all other Servers.  Running package.sh server-base will perform a 'yum update' as well as install Ansible.
This is the server that is provisioned via shell from the base AMI. After this stage we expect ALL further updates to be performed by Packer and Ansible

## Distro / Provision

This folder is contains the Ansible configurations setting the version variables of the software to be installed performing packaging

# Special Directories

Because we use both Centos 6 and 7 we will want to create distributions of both types.  See [Packaging](../../package/README.md)

# VMI Properties

The VMIs to be used when deploying a cluster of this distribution type are defined in this file.  The file is prefixed with the cloud providers region name followed by '.vmi.properties'
