#!/usr/bin/env bash
# B A S H ! ! !

# Show running services and open server ports

# Validate that Init has been run

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

POD=""

if [ -n "$1" ]; then
  POD="$1"
fi

CONTAINER=""

if [ -n "$2" ]; then
  CONTAINER="-c $2"
fi


#NAMESPACE=""

#if [ -n "$" ]; then
#  NAMESPACE="-n $2"
#fi


kubectl get nodes -o json | jq .items[].spec.taints
