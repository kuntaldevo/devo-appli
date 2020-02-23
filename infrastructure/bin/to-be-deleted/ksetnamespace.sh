#!/usr/bin/env bash
# B A S H ! ! !


# Validate that Init has been run

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

NAMESPACE=$1

if [ -n "$NAMESPACE" ]; then
  CONTEXT=$(kubectl config current-context)
  kubectl config set-context $CONTEXT --namespace=$NAMESPACE
else
  echo "$ERROR Please pass in a namespace."
fi
