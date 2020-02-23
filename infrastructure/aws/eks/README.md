# EKS Getting Started

This document will help describe how to install an EKS cluster, the Paxata App and and supporting infrastructure

# Local tooling installatin and setup

There are two options to getting your EKS cluster up and ready.

1.  Manually install everything locally on your PC using the following directions...
1.1 [Getting Started](../../installation/README.md)
1.2 Install Kube Control CLI
1.2.1 MacOS:  brew install kubernetes-cli
1. Install the AWS Authenticator as seen further down this README

### OR

1. Install Docker
1.1 On MacOS I prefer using `brew install docker`
1. Then follow the [Easy Installer](../../easyinstallere/README.md)

#  Other Pre-Requiists

* 'devops-policies' must have been applied.
* You must have authentication credentials in order to login to AWS.  Contact Devops for more details

## Install AWS Authenticator

Kubectl can use the AWS Authenticator to automatically get a token from AWS for Kubernetes access.

See:  https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html

MacOS:  https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator

Make it executable:  ```chmod +x ~/Downloads/aws-iam-authenticator```

Move it into your path:  ```mv ~/Downloads/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator```

#Create Cluster

Now you can run remote commands to manage your cluster
* init.sh
* remote-init
* remote-up

*See the Known errors / troubleshooting near the end of this page*

# Post Run

Terraform has updated your personal Kubernetes CLI configuration in ~/.kube/config and set your current context to the name of the cluster you just created.

# Validate KUBECONFIG is set correctly

>  kubectl config view

>  kubectl cluster-info



# Install Application Pre-Reqs

Get the latest installation zip from TeamCity.

Dev:

Prod:  http://tc.paxatadev.com/repository/download/Master_Assemble_Hiya/719382:id/k8s-deployment-prod.zip

Unzip and run the deploy.sh.

NOTE:  Your local Kube Config must be set to the cluster you wish to modify

**You are now ready to begin using your cluster.**

The following is for advanced users / the Devops team.

# Dashboard UI

https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview?namespace=_all

# Dump Cluster configuration

>  kubectl cluster-info dump

# View Component Status

>  kubectl get componentstatuses




# Known issues

```
1 error(s) occurred:

* aws_eks_cluster.eks: 1 error(s) occurred:

* aws_eks_cluster.eks: error creating EKS Cluster (paxata-beta): InvalidParameterException: Error in role params
```

```
Error: Error applying plan:

1 error(s) occurred:

* null_resource.aws-access: Error running command 'kubectl apply -f .kube/config-map-aws-auth.yml': exit status 1. Output: error: unable to recognize ".kube/config-map-aws-auth.yml": Get https://CB2B74B6F9DEA35080CD22A8D4670403.sk1.us-east-1.eks.amazonaws.com/api?timeout=32s: dial tcp 18.209.254.250:443: i/o timeout
```

**SOLUTION:** ReReun the script. These appear to be a timing/readiness issue
