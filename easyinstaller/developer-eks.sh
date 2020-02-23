#!/usr/bin/env bash
# B A S H ! ! !

# Using the local systme credentials Grab the image from ECR and run it with some params
source ./bin/ecr-properties.bash


#make sure we have the correct image
source ./bin/pull-from-ecr.bash "devops-application/developer-eks:latest"

export REQUIRED_ACCOUNT_ID="011447054295"

#Set a Developer Flag so we know to modify some behaviour
export BRANCH_NAME='DEVOPSS-705.ECR'

#Set a Developer Flag so we know to modify some behaviour
export DEVELOPER='true'

###  Setup the resonable defaults for the developers to use
export PROVIDER_ID='aws'

# Set the Customer Id to their username, finding their name from Git's user.email
export CUSTOMER_ID=`git config user.email | awk -F"@" '{print $1}' `

# Developers only use the West-2 Region
export REGION_ID="us-west-2"

export KUSTOMIZE_CONFIG='dev-eks'

#source "${PROJECT_ROOT}/infrastructure/bin/remote.bash"

export ACTION="$1"

#Run the Image. Using my local credentials

#docker run --name paxinst --rm \
#  --mount type=bind,source="$HOME/.aws",target=/root/.aws \
#  -i -t paxinst bash

docker run  \
--env REQUIRED_ACCOUNT_ID="${REQUIRED_ACCOUNT_ID}" \
--env CUSTOMER_ID="${CUSTOMER_ID}" \
--env DEVELOPER="${DEVELOPER}" \
--env PROVIDER_ID="${PROVIDER_ID}" \
--env BRANCH_NAME="${BRANCH_NAME}" \
--env REGION_ID="${REGION_ID}" \
--env CLUSTER_ID="${CLUSTER_ID}" \
--env ACTION="${ACTION}" \
--mount type=bind,source="$HOME/.ssh",target=/root/.ssh \
--mount type=bind,source="$HOME/.aws",target=/root/.aws \
  devops-application/developer-eks:latest


if [[ $ACTION == "up" ]]; then
  # Setup the KubeConfig locally and not on the Container
  aws eks update-kubeconfig --name "${CUSTOMER_ID}-${CLUSTER_ID}" --profile default --region $REGION_ID
fi
