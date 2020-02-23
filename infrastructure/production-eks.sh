#!/usr/bin/env bash
# B A S H ! ! !

# Set and environment variable that allows other scripts to know the main relative context
# Only relative path we will code for.  Once we have the project_root we can use full paths
source "../tooling/project-root.sh"
export PROJECT_ROOT

REQUIRED_ACCOUNT_ID="365762923425"

###  Setup the resonable defaults for the developers to use
export PROVIDER_ID='aws'

# Developers only use the West-2 Region
export REGION_ID="us-east-1"

export CUSTOMER_ID="paxata"
export CLUSTER_ID="prod"

source "${PROJECT_ROOT}/infrastructure/bin/lib/remote.bash"
