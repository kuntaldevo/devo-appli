
Installing Calico is confusing (to me) because there are two ways to install it.

1. Using Calico's:  https://docs.projectcalico.org/v3.8/getting-started/kubernetes/installation/calico
2. Following AWS:  https://docs.aws.amazon.com/eks/latest/userguide/calico.html  

For now we are using AWS EKS's direction

kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/release-1.5/config/v1.5/calico.yaml
