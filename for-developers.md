
# The following process allows you to create a single EKS cluster for your personal use.



## Instructions on how to create a personal area to perform your work in the cloud.

Pre-requisites that need to be installed:
- kubectl (kubernetes cli)
- aws cli
- aws-iam-authenticator
  - [AWS Reference](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
  - Scroll Down to "To install aws-iam-authenticator for Amazon EKS"
  - [Simplified Directions](aws-authenticator-macos.md)
- terraform (brew install terraform@0.12)
- jq (brew install jq)
- gnu getopt (brew install gnu-getopt; update your path to make sure it is first)
- [saml2aws](saml2aws.md) needs to be installed and configured. Make sure that you can successfully execute `saml2aws login` before continuing

Information on how to install required tooling is available at [Getting Started](installation/README.md)

## Assumptions....

You MUST have your Git configured with your user.name & user.email set.

Run:  `git config --list` to verify

The name of the EKS cluster will be the first part of your email address plus "-dev-eks". So if your git `user.email` is `pfried@paxata.com` then your eks cluster name will be `pfried-dev-eks`

## Update your Git User Email

But use your email

>  git config --global user.email "pfried@paxata.com"


## Authenticate with AWS

Run:  > saml2aws login

For more information see [help with saml2aws](saml2aws.md)

## Create your kubernetes client configuration

> Run: ./developer-eks.sh up

NOTE: The default is to use region us-west-2.  Until we get more space in that region, there is a region ( -r ) flag where you can change the region to us-east-1

> Run: ./developer-eks.sh -r us-east-1 up

This will start up a cluster with the default configuration, and set your current context for `kubectl` so that all `kubectl` commands will now point to the eks cluster.

After the next step, then `kubectl` should now be fully functional.

## Verify you can interact with the cluster

Run: > kubectl get nodes

```
NAME                                           STATUS   ROLES            AGE   VERSION
ip-10-241-137-108.us-west-2.compute.internal   Ready    spark-server     17s   v1.12.7
ip-10-241-144-185.us-west-2.compute.internal   Ready    general-server   18s   v1.12.7
ip-10-241-170-215.us-west-2.compute.internal   Ready    mongo-server     19s   v1.12.7
```

## More options
 Now you can either bring up the devops provided control-plane or do what you need to with kubectl.	You can run `./developer-eks.sh -h` to get a basic help message. At the moment, the aws region is the only thing that is configurable with a flag on the script. To change other parameters such as the node type and number of nodes, you'll need to modify `infrastructure/aws/eks/variables.tf`.

# Destroy your EKS Cluster

> Run: ./developer-eks.sh down

( be sure to add any other flags you specified in 'up')


# Add Control Plane on your EKS Cluster via Terraform

TODO:  the following is incorrect

Run:  remote-up.sh control-plane
