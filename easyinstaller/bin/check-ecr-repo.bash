#!/usr/bin/env bash
# B A S H ! ! !

# Create an ECR repo if it doesn't exist

REPO_NAME="$1"

aws ecr describe-repositories --repository-names "$REPO_NAME" --region us-west-2
EXIT_CODE="$?"

if [[ $EXIT_CODE != "0" ]]; then

  aws ecr create-repository --repository-name "$REPO_NAME" --region us-west-2

fi
