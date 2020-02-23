#!/usr/bin/env bash
# B A S H ! ! !

# Because, in order to create the Terraform service account we need some outputs, we will just do this in Bash
echo "Begining to Create user for Terraform"

# Use the generated kubectl file
export KUBECONFIG=".kube/kubeconfig.yml"

echo "Create a new service account for terraform"
kubectl -n kube-system create sa terraform

echo "Grant proper access for terraform"
kubectl create clusterrolebinding terraform --clusterrole cluster-admin --serviceaccount=kube-system:terraform

echo "Get the unique name of the generated secret"
secret=$(kubectl get sa terraform -n kube-system -o json | jq -r .secrets[].name)

echo "Get the bearer authorization token for the terraform user and save the credentials in the kubectl configuration"
user_token=$(kubectl get secret $secret -n kube-system -o json | jq -r '.data["token"]' | base64 -D )

#Update the .kube Configuration

echo "Save the cluster specific credentials in the kubectl configuration"
kubectl config set-credentials "${ENV_KEY}-tf" --token $user_token

echo "Create a new context for the EKS cluster with the above credentials for terraform to use"
kubectl config set-context "${ENV_KEY}-tf" --cluster=${ENV_KEY} --user="${ENV_KEY}-tf"

#Repeat the same in the default location ~/.kubectl/config
unset KUBECONFIG

echo "Save the cluster specific credentials in the kubectl configuration"
kubectl config set-credentials "${ENV_KEY}-tf" --token $user_token

echo "Create a new context for the EKS cluster with the above credentials for terraform to use"
kubectl config set-context "${ENV_KEY}-tf" --cluster=${ENV_KEY} --user="${ENV_KEY}-tf"
