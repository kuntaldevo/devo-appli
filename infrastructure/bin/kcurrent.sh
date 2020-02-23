#!/usr/bin/env bash
# B A S H ! ! !

# Out put the context and the CLUSTER

# Validate that Init has been run

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

#Get the Current Context
CONTEXT=$(kubectl config view  -o jsonpath='{.current-context}')

echo "$FYI Using Context:  $CONTEXT"

#JQ seems to require the Double Quotes for 'contains'
SELECT=" .[] | select(.name | contains(\""$CONTEXT"\")) "

CLUSTER=$(kubectl config view -o json | jq .contexts | jq "$SELECT" | jq -r ".context.cluster" )

NAMESPACE=$(kubectl config view -o json | jq .contexts | jq "$SELECT" | jq -r ".context.namespace" )

echo ""

echo "$FYI Cluster is:  $CLUSTER"
echo ""

if [ -n "$NAMESPACE" ]; then
  echo "$FYI Namespace is:  $NAMESPACE"
fi

EKS_CLUSTER=$( echo $CLUSTER |  awk -F/ '{print $NF}')

export EKS_CLUSTER
