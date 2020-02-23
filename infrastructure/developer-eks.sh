#!/usr/bin/env bash
# B A S H ! ! !

# Set and environment variable that allows other scripts to know the main relative context
# Only relative path we will code for.  Once we have the project_root we can use full paths
source "../tooling/project-root.sh"
export PROJECT_ROOT

REQUIRED_ACCOUNT_ID="011447054295"

#Set a Developer Flag so we know to modify some behaviour
export DEVELOPER='true'

###  Setup the resonable defaults for the developers to use
export PROVIDER_ID='aws'

# Set the Customer Id to their username, finding their name from Git's user.email
export CUSTOMER_ID=`git config user.email | awk -F"@" '{print $1}' `

export CLUSTER_ID="dev-eks"

# Developers only use the West-2 Region
export REGION_ID="us-west-2"

export KUSTOMIZE_CONFIG='dev-eks'

source "${PROJECT_ROOT}/infrastructure/bin/lib/remote.bash"
