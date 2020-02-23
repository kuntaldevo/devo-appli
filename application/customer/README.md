
# Architecture Concepts

The combination of the Customer Id and the Cluster Id define the ENV-KEY

To begin working with infrastructure the CLI needs to know the following.  These values are provided to infrastructure's init.sh script.

* The Customer Id: This corresponds directly to a subfolder under application / customer.  CLI initialization will fail if not set.
* The Customer's Cluster Id:  This corresponds directly to a subfolder under a named customer's folder.
* The Cloud Provider : This identifies the targeted cloud to work with.  This value is independent of the ENV-KEY
* The Region Id: of the cloud provider's location the customer's cluster will be created/modified/deleted.  This value is independent of the ENV-KEY

to initialize the shell's ENV-KEY run init.sh passing in the Customer / Cluster

init.sh will look in the application / ${customer-id} / ${cluster-id} folder for an cluster.config file

# Customer Directory Required Files / Settings

Contains customer specific settings like Cloud Provider Credentials

## The Customer's cloud provider Credentials

Prefixed with the cloud provider id and ending in ".credentials" this file defines the variables in bash to define when a command is run.  Most of the time it is assumed that the credentials to access a cloud provider will be defined externally to this project.  For instance AWS can use the 'default' credentialing that is defined in ~/.aws

### Customer Properties

Required file name: customer.properties

This file is used by terraform to define infrastructure properties that are the same across all clusters and all regions.

Examples include:

* Company IP whitelist
* Company defined access credentials

## Customer's Region Specific Configuration

Note: Optional

A Customer may also have specific properties for a specific {region-id}.  These files are found at ${customer-id}/region/${region-id}.properties file. The file can contain configurations that are specific to that region.  This file will override the customer's properties or any cluster properties.

### Common Vars

1. aws-key-pair : an existing key pair in the region to use to assign to the infrastructure
1. public-domain : the URL suffix to use for the UI and Proxy servers. ie. paxata.com vs paxatadev.com

# Customer's Cluster Sub-Directory

This directory defines setting that are specific to a cluster.  These values can be broken down further to be specific for certain regions if required.  Generally, the settings here are independent regardless of the cluster's region, distro, or iSize.

## Customer's Cluster Specific Configuration

Required file name: cluster.config

This file is written in Bash Script and defines the major components that will be used to configure the rest of the infrastructure.  This file defines, the selected server sizing, The Distribution ( aka Version ) of the product to deploy, and the networking infrastructure configuration that terraform will use.

Cluster configuration file is defined in bash, and must define the following...

* INFRASTRUCTURE_ID = the terraform configuration ( directory ) in the infrastructure directory.  Directory is below a provider Id's subfolder
* DISTRO_ID = The distribution that will be used.  Corresponds to application/distro/${DISTRO_ID}
* ISIZE_ID = The sizing of the VMIs like instance-type & volume size. Corresponds to application/isize/${ISIZE_ID}
  * Note: Only one size can be defined and is used across all regions.
* APPROVER_EMAIL = The approver of the cluster.  This is an environment variables to allow it be used for infrastructure tags.

## Cluster Properties

File name is :  `cluster.properties`

This is the primary location that a customer would use to define the configuration "features" that are cluster specific.  The file is optional, though a warning is generated to hi-light that the file is missing.

### Feature Definitions

Features are flags that specify a new instance, what it is and what its settings are. Some features include setting the Library type. These feature values are passed to the infrastructure at create time as user-data.  There is an Ansible playbook & roles ( \*-provisioner ) that then read the user data and perform certain pre-defined actions.

See: [Feature Definitions](features.md)

### node-policies

Set the 'node-policies' variable for EKS & Terraform.  Node Policies are only the name of the policy and NOT the entire ARN.  The ARN is calculated later at creation time using the ACCOUNT-ID of the user that is creating infrastructure.

# Packaging

## Customer's Packaging Settings

Note: Optional

Specific settings, if needed, for packer to work in a specific region.

This was added to allow packer to build in a specific VPN and Subnet if so required.  Specific VPN/Subnet combinations are used to allow the packaging to access Paxata internal repositories ( Nexus & Team City)
