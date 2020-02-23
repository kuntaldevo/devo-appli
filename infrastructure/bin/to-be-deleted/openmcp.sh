#!/usr/bin/env bash
# B A S H ! ! !


# Validate that Init has been run

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

source "${PROJECT_ROOT}/infrastructure/bin/kcurrent.sh"


if [ -z "$EKS_CLUSTER" ]; then
    echo "$ERROR  Unable to determine the current cluster."
    exit 1
fi


echo "Custer is:  $EKS_CLUSTER"

open "https://mcp-$EKS_CLUSTER.paxata.ninja:5000/#/customer"
