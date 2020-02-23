
# Packaging

Create predefined machine images to use when creating infrastructure.

## Architecture

There are three phases when creating Paxata's machine images.  AMI IDs are region specific, therefore you will have to perform these steps in any region you desire to use.

First there is creating a "Root AMI". This AMI is just a copy of an existing AMI from the AWS Marketplace.

Second is creating the Server AMI.  The Server AMI starts with the Root AMI, performs a package update, and then installs Ansible and any required libraries that Ansible requires.  From this point, creating any specific server type ( Core, Pipeline, etc ) will modify the the Server AMI via ansible.


# Pre-requites

1. Your region will need to be able to access an IAM role named 'packer-build'.  This IAM role allows the image begin provisioned to connect to the S3 file repositories.
1. 1. At the moment there is a single role that allows the AMI to access a special S3 bucket called 'paxata-secrets'.  This bucket contains various private keys that should not appear in source control.
1. Packer will create a temporary SSH Key for its own use, so there is no need to have any ready at this time
1. The region will need to have a Default VPC available.  Packer by default packages in the default VPC.  If Packaging with Nexus or Team City then properly configured VPN/Subnet needs to be provided in the "{customer}/package/{region-id}.config" file

# Prepare a new Region

Use the init.sh script to enter the proper version you require and region in which to work.

Once you are in the sub-shell ( your command prompt will change )...


## Build the Root AMI

The Packer scripts automatically scan and use the latest image available

Centos 6

NOTE: Change your region as appropriate

```./init.sh --distro centos-6 --region us-east-1
```

Centos 7

NOTE: Change your region as appropriate

```./init.sh --distro centos-7 --region us-east-1
```

## Creating the Base AMI

Run: > package.sh base-vmi

The Base AMI has the tagged with the proper distro-id and the role-id of root-server.  This is basically an exact copy of the AWS Marketplace Image

## Creating the Server AMI

Run: > package.sh server-base

This server has been patched and Ansible installed.  All servers using this image will only use Ansible for configuration

The Base AMI has the tagged with the proper distro-id and the role-id of base-server.

# Initialization Packaging

Change your directory to the 'package' subdirectory

Run the Shell initializer, init.sh passing the required flags

Run init.sh {config}

Configuration Flags,

--region : the cloud provider's region where the VMIs will be stored
--distro : sets the folder under the application/distro directory to be used.

--customer : OPTIONAL sets the directory to use that is under application/customer. Default: 'paxata'
--provider : OPTIONAL set the cloud-provider being used to package VMIs. Default: 'aws'

Once successful, this adds the package/bin directory to your path as well.

# Credentials

## AWS

Use the credentials that are set in the users's home .aws directory.  Credentials can be overridden by setting standard AWS environment variables.

By default packer will use the [default] User profile as defined in ~/.aws

To Override: export AWS_PROFILE=aws_prod_account_id

## AWS MFA

See [Using AWS MFA](../aws-mfa.md)

## SAML to AWS

See [Using SAML to AWS](../saml2aws.md)

# Package Script

Run:  package.sh {optional -debug} {instance-type} {optional  playbook-override }

The server type corresponds to a sub-folder in this directory.  The script will then run the matching playbook in the Provision directory.

## Instance Type Parameter

is the folder where the package.sh should find the packer script.  By default the script will run a matching named playbook in provision/ansible

## Optional: Playbook Override

When passing in an override the packer script will use the same folder to find it's script but then packer will execute the playbook override instead.

## Optional Dash Debug

Enable the packer debugging feature that allows you to attach to the packer instance

# Using your new AMI/VMI

Once complete, copy and paste the reported AMI/VMI id to the Distro/{version}/{region}.vmi.properties

# Other tools and commands

## Validate

If you require more information regarding the setup of your shell you can run validate to output the more important pre-set shell environment variables.

Run: > validate.sh

## Azure:

NOTE:  In Azure, this app is registered as 'devops-automate'

There is a service principle defined with the following Credentials

Retrying role assignment creation: 1/36
{
  "appId": "112b9575-aa1b-4c57-b76b-6faab7041720", --> Client Id / Application Id
  "displayName": "devops-automate",
  "name": "http://devops-automate",
  "password": "ea3735ff-a86a-4c58-ac16-97b3db2917a8", --> Client Secret
  "tenant": "0f4618be-f39c-4b96-a438-6beecbf48e27" --> Tenant Id
}

### Packaging in Azure

Azure uses resource groups that will store the created VMI.  Before creating the VMI you need use the infrastructure tools first and create the storage resource group

# Other Sub-Directories

## Bin

When init.sh is run this directory is pre-pended to the shell's path.

## Lib

Support Scripts for performing Packaging for the scripts in the lib directory
