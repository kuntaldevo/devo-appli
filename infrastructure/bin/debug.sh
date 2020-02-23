#!/usr/bin/env bash
# B A S H ! ! !

# Validate that Project Root is set
if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Trying to find it."
    source "../tooling/project-root.sh"
    export PROJECT_ROOT
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

WHAT="$1"


# https://kubernetes.io/docs/reference/kubectl/jsonpath/

kubectl get pods -o=jsonpath='Items[?starts_with(metadata.name,"external")]'

kubectl get pods -o=jsonpath='{.items[*].metadata.name}' -n kube-system

kgans -l paxata.com/is-customer=true

# https://docs.aws.amazon.com/cli/latest/reference/autoscaling/describe-scaling-activities.html

aws autoscaling describe-auto-scaling-groups --region us-west-2 --query "AutoScalingGroups[?starts_with(AutoScalingGroupName,'thindanov') ]"

aws autoscaling --region us-west-2 describe-scaling-activities  --max-items 10 --query "Activities[?starts_with(AutoScalingGroupName,'paxata-perf-eks') ]"

# Get all instances with a tag of Owner

aws ec2 --region us-west-2 describe-instances --filters "Name=tag-key,Values=Owner"

# Get all instances with a Name that starts with
aws ec2 --region us-west-2 describe-instances --filters "Name=tag:Name,Values=sadey-dev-eks*"

# Get instances using q query
#https://github.com/aws/aws-cli/issues/2206
aws ec2 --region us-west-2 describe-instances --query "Reservations[].Instances[?Tags[?Key == 'cluster-id' && contains(Value, 'dev-eks')]][]"
