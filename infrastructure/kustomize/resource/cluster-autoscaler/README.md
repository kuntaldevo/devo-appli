
# Cluster Autoscaler

Cluster autoscaler is versioned in a pattern that follows Kubernetes versioning.

Because we are on 1.14 we should only use a 1.14

Releases:  https://github.com/kubernetes/autoscaler/releases

We use the Auto-Discovery Setup

https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md

# Kustomize Update process

Because there are some tricky replacement variables, I have copied the latest yaml from the following...

https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml

and made the following manual changes

## Updated to latest version

Deployment / spec / template / spec / containers

- image: gcr.io/google-containers/cluster-autoscaler:v1.14.6


## Added replacement variable

Deployment / spec / template / spec / containers / command

- --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/<YOUR CLUSTER NAME>

TO

- --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/$(CLUSTER-NAME)
