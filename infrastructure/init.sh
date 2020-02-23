#!/usr/bin/env bash
# B A S H ! ! !


#Define Defaults
export PROVIDER_ID="aws"
export CUSTOMER_ID="paxata"


# Set and environment variable that allows other scripts to know the main relative context
# Only relative path we will code for.  Once we have the project_root we can priarily use full paths
source "../tooling/project-root.sh"
export PROJECT_ROOT

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

###
# Validate GetOpt is of correct version, if Mac see Wiki Devops Onboarding
getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
  echo "${ERROR}The Latest version of GetOpt is required."
  echo "${ERROR}If Mac see Wiki Devops Onboarding."
  exit 1
fi

OPTIONS="h"
LONGOPTIONS="customer:,cluster:,provider:,region:,stage:"

# -temporarily store output to be able to check for errors
# -e.g. use “--options” parameter by name to activate quoting/enhanced mode
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi

# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        --customer)
            CUSTOMER_ID="$2"
            shift
            shift
            ;;
        --cluster)
            CLUSTER_ID="$2"
            shift
            shift
            ;;
          --stage)
              STAGE_ID="$2"
              shift
              shift
              ;;
        --provider)
            PROVIDER_ID="$2"
            shift
            shift
            ;;
        --region)
            REGION_ID="$2"
            shift
            shift
            ;;
        *)
            break
            ;;
    esac
done

### The Validate there is a Customer is set
if [[ -z "$CUSTOMER_ID" ]]; then
  echo "$ERROR flag --customer required."
  exit 2
fi

### The Validate there is a Cluster is set
if [[ -z "$CLUSTER_ID" ]]; then
  echo "$ERROR flag --cluster required."
  exit 2
fi

### The Validate there is a Provider is set
if [[ -z "$PROVIDER_ID" ]]; then
  echo "$ERROR flag --provider required."
  exit 2
fi

### The Validate there is a Region is set
if [[ -z "$REGION_ID" ]]; then
  echo "$ERROR flag --region required."
  exit 2
fi

# Define bin location path env variable
export INFRASTRUCTURE_BIN="${PROJECT_ROOT}/infrastructure/bin"

#Validate the Customer and Cluster directories exist
source "${INFRASTRUCTURE_BIN}/lib/validate-init-params.bash"

#Set the shell with the values passed in
export CUSTOMER_ID
export CLUSTER_ID
export STAGE_ID
#Cloud Provider Env Vars
export REGION_ID
export PROVIDER_ID

#Add some helper tooling scripts to the user's path
export PATH="${INFRASTRUCTURE_BIN}:${PROJECT_ROOT}/tooling/bin:${PATH}"

echo "Entering Shell"
# Open new interacive Bash setting up some conviences
exec /bin/bash --rcfile "${PROJECT_ROOT}/infrastructure/bin/lib/shell-config.bash" -i
