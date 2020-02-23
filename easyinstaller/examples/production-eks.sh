#!/usr/bin/env bash
# B A S H ! ! !

# Set and environment variable that allows other scripts to know the main relative context
# Only relative path we will code for.  Once we have the project_root we can use full paths
#source "../tooling/project-root.sh"
#export PROJECT_ROOT


#**To Build:**
docker build -t paxinst automatic/

echo "$FYI Completed Image Creation."

export REQUIRED_ACCOUNT_ID="365762923425"

export PRODUCTION='true'

###  Setup the resonable defaults for the developers to use
export PROVIDER_ID='aws'

# Set the Customer Id to their username, finding their name from Git's user.email
export CUSTOMER_ID='paxata'

# Developers only use the West-2 Region
export REGION_ID="us-east-1"

export CLUSTER_ID='production'

#source "${PROJECT_ROOT}/infrastructure/bin/remote.bash"

export ACTION="$1"

#Run the Image. Using my local credentials

#docker run --name paxinst --rm \
#  --mount type=bind,source="$HOME/.aws",target=/root/.aws \
#  -i -t paxinst bash

docker run --rm \
--env REQUIRED_ACCOUNT_ID="${REQUIRED_ACCOUNT_ID}" \
--env CUSTOMER_ID="${CUSTOMER_ID}" \
--env DEVELOPER="${DEVELOPER}" \
--env PROVIDER_ID="${PROVIDER_ID}" \
--env REGION_ID="${REGION_ID}" \
--env CLUSTER_ID="${CLUSTER_ID}" \
--env ACTION="${ACTION}" \
  --mount type=bind,source="$HOME/.aws",target=/root/.aws \
  paxinst


if [[ $ACTION == "up" ]]; then
# Setup the KubeConfig locally and not on the Container
  aws eks update-kubeconfig --name "${CUSTOMER_ID}-${CLUSTER_ID}" --profile default --region $REGION_ID
fi
