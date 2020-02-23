
# Infrastructure

This area manages the concrete pieces of a cluster. In this folder is the terraform configurations that define our infrastructure as code.  Some of the things include, Networking Configuration, DNS, Firewalls and Network Security

# Architectural Overview

A cluster in the cloud has several components

## Defining your Desired Infrastructure

The Infrastructure directory heavily relies on the contents of the properties and config files defined in application/customer.

Before running the commands in this location you will want to closely review the [information in Application](../application/README.md) as well as [information in Customer](../application/customer/README.md)  In these locations you will learn how to define your library type and setting other features.

## Terraform State Storage & Concurrent Change Locking

There is a storage area, that allows Terraform to store its state files.  This 'tfstate' storage location is created first and only needs to be created once.  In conjunction there is a noSQL database that provides Terraform with a global configuration lock.  This lock prevents more than one user from changing the infrastructure at the same time.

If you are using AWS the state is stored in an s3 bucket.  Change Concurrent lock is via Dynamo-DB

## The Virtual Private Cloud

1. A VPC is defined that contains all of the networking configuration and servers.  Each cluster's network is isolated from each other.

# Pre-requites

### AWS 2FA

Have AWS-MFA configured

See [Using AWS MFA](../aws-mfa.md)

### Cluster SSH access

1. Your region will need to have an available key-pair that you can use to access the running cluster,  Once created you will set the variable 'aws-key-pair' in the Customer configuration

See,  [Customer Readme](../application/customer/README.md) for more information and how to set your key pair.

# Initialize your shell

Change your directory to the 'infrastructure' subdirectory

Run the Shell initializer, init.sh passing the required flags

* --customer : sets the directory to use that is under application/customer
* --cluster : sets the directory to use that is under the defined customer Directory
* --provider : OPTIONAL sets the cloud provider. Default is AWS
* --region : sets the cloud-provider's region that this customer's cluster will be built & managed

# STAGE ( optional )

There is now a third level to go along with Customer and Cluster, that being Stage.

Stage is specified at init.sh and is post-pended with the Customer-Cluster naming convention


If successful, you will enter a sub-shell and notice a customized bash prompt.  The bash prompt shows the Customer, Cluster, Optional Stage and Region in use.  This will help make it clearer that you are using a specialized shell as well as re-enforcing that you are executing commands in the proper area.

# Initialize your Cloud

Terraform requires a couple of pre-existing items to be available before creating your cluster.  This only needs to happen once and at the very beginning.

1. A File Store location ( AWS=S3, Azure=Storage) to contain the remote state.
1. A Lock File ( AWS=dynamodb, Azure=Map) to prevent concurrent modification

TODO: I Removed Cloudtrail,  because of audit trail limit per person: Additionally an audit mechanism is added for change tracking, ( AWS=cloudtrail, Azure=TODO )

Run:

> remote-init.sh

# Create a Library

The default for library storage is local to the Core-UI server.  For most installations you will want to store the library data in a larger location like S3.
The name of the S3 bucket to be used as the library must follow the expected format,

1. start with "library."
1. the env-key
1. then a dot ( . )
1. the region of the bucket and must match the region of the cluster being managed.  This is due to bucket names must be globally unique and is an offshoot of being able to easily install a cluster into multiple regions.
1. ends with ".devops.paxata.com"

  ie.  library.paxata-sbc.us-east-2.devops.paxata.com

## Managing a Library in s3

After remote-init has been completed you can create your library via terraform if you like.  Using terraform is best for basic testing of a cluster when you're 100% certain you want to delete the library.

> remote-up.sh library-s3

likewise to delete the library and its contents

> remote-down.sh library-s3

For additional safety in more critical areas, it is probably best to manually manage your library.


# Create your Infrastructure

Run:

> remote-up.sh

Options:

--wfh : If working from home you can add the flag to allow your IP to be automatically registered with the security group

Once this completed and you are presented with the following similar output

```
Apply complete! Resources: 39 added, 0 changed, 0 destroyed.

Outputs:

cluster-public-url = paxata-min.paxatadev.com
...
ssh-command = ssh -i ~/.ssh/dev-keypair-east-2.pem centos@paxata-min.paxatadev.com
```

You can now access your cluster, though note that some servers / services may still be starting up.

## Destroying your Infrastructure

Run:

> remote-down.sh

### Manual Cluster Termination
1. find cluster info in aws eks dashboard
	- ensure region is correct
1. `./init.sh --customer --cluster --region`
1. `remote-down.sh eks-infra` (mongo, etc.)
1. `remote-down.sh` (nodes)
	- if prompted for values, enter anything, it won't be used
1. manual deletions
	- control plane service
	- deployments
	- \<installation-namespace\>
	- ingress
	- mongo
	- load balancer services
1. delete cluster in aws eks
1. iam in aws
	- search iam for cluster
	- delete roles
1. delete instance profile
	- may have to search: `aws iam list-instance-profiles`
	- e.g.: `aws iam delete-instance-profile --instance-profile-name davebrewster-dev-eks.us-west-2`

## UN-Initialize your Cloud

NOTE: Removal of the Cloud Init artifacts is currently a manual process.

Manually delete the tfstate.${env-key}.${region-id}.devops.paxata.com
Manually delete the corresponding dynamodb table that is used for terraform locking


# Other tools and commands

## Validate

If you require more information regarding the setup of your shell you can run validate to output the more important pre-set shell environment variables.

Run: > validate.sh

## Encode Core Site XML

```echo `cat core-site.xml` | base64 > core-site.xml.encoded```
