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

NAMESPACE=""

if [ -n "$1" ]; then
  NAMESPACE="-n $1"
fi


kubectl get pods $NAMESPACE
