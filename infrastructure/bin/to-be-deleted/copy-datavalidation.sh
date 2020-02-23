#!/usr/bin/env bash
# B A S H ! ! !


# Validate that Init has been run

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

DATE="$1"

if [ -z "$DATE" ]; then
    echo "Required Entry, a date in the form of 'yyyy-mm-dd' "
    exit 1
fi

aws --profile devops-datavalidation s3 sync s3://paxata-datavalidation/prod-e3-mongo2/"$DATE"/ s3://library."$CUSTOMER_ID-$CLUSTER_ID.$REGION_ID".devops.paxata.com/
