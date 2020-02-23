#!/usr/bin/env bash
# B A S H ! ! !


# Validate that Init has been run

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

### Begin getopt setup
OPTIONS=h
LONGOPTIONS=profile:,region:

# -temporarily store output to be able to check for errors
# -e.g. use “--options” parameter by name to activate quoting/enhanced mode
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt  --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# Init variable for optional Target Parameter
NAME=""
PROFILE=""
REGION="--region $REGION_ID"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
      --profile)
              PROFILE="--profile $2"
              shift 2
              ;;
      --region)
              REGION="--region $2"
              shift 2
              ;;
      *)
            NAME="$2"
            shift
            break
            ;;
    esac
done
### End getopt

echo "$FYI Listing EKS Clusters in $REGION"

aws eks list-clusters $PROFILE $REGION