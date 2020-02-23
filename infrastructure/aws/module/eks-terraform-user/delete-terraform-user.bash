#!/usr/bin/env bash
# B A S H ! ! !

# Because, in order to create the Terraform service account we need some outputs, we will just do this in Bash

echo "------------------------"
echo "------------------------"
echo "------------------------"
kubectl config use-context ${ENV_KEY}

echo "Create a new service account for terraform"

echo "Grant proper access for terraform"

echo "Get the unique name of the generated secret"

echo "Get the bearer authorization token for the terraform user and save the credentials in the kubectl configuration"

echo "Save the credentials in the kubectl configuration"

echo "Create a new context for the EKS cluster with the above credentials for terraform to use"
