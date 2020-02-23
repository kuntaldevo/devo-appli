# Configuring Using TeamCity to use paxata-test-eks

A TC Agent will need the following tools...

1.  The Kubernetes CLI, https://kubernetes.io/docs/tasks/tools/install-kubectl/
1.  The AWS CLI, https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
1.  The AWS Authenticator for EKS, https://github.com/kubernetes-sigs/aws-iam-authenticator

# Setup AWS

Create a directory, typically in the users home directory

`~/.aws`

Create a 'credentials' file with the following contents
```
[default]

[team-city]
aws_access_key_id     = {check lastpass for Teamcity EKS}
aws_secret_access_key = {check lastpass for Teamcity EKS}
```

Create a 'config' file with the following contents

```
[profile eks-cluster-admin]
role_arn = arn:aws:iam::011447054295:role/eks-cluster-admin
source_profile = team-city
output = json
region = us-west-2
```

# Get the .kube config from AWS

aws eks update-kubeconfig --name paxata-test-eks --profile eks-cluster-admin


# To Run Kubectl commands

In the shell, set an environment variable

```
export AWS_PROFILE=eks-cluster-admin
```

# Test your connection

Run:  kubectl get nodes
