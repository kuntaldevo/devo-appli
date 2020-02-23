#!/usr/bin/env bash
# B A S H ! ! !


#Define Defaults
export PROVIDER_ID="aws"

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
LONGOPTIONS="customer:,cluster,region"

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

### If the cluster is set then the region is required as well
if [[ -n "$CLUSTER_ID" ]]; then

  ### The Validate there is a Region is set
  if [[ -z "$REGION_ID" ]]; then
    echo "$ERROR flag --region required when cluster is set"
    exit 2
  fi

fi

# Define bin location path env variable
export APPLICATION_BIN="${PROJECT_ROOT}/application/bin"
export INFRASTRUCTURE_BIN="${PROJECT_ROOT}/infrastructure/bin"

# Validate Customer Directory Exists
CUSTOMER_DIR="${PROJECT_ROOT}/application/customer/${CUSTOMER_ID}/"

### Validate the Customer Directory
if [[ ! -e "${CUSTOMER_DIR}" ]]; then
   echo "Directory '${CUSTOMER_ID}' does not exist in 'application/customer/'."
   echo "Creating the directory for the customer ${CUSTOMER_ID}"
   mkdir -p ${CUSTOMER_DIR}
fi

#Set the shell with the values passed in
export CUSTOMER_ID
export CLUSTER_ID
export STAGE_ID
#Cloud Provider Env Vars
export REGION_ID
export PROVIDER_ID


#  Don't want to do this yet at this stage
#export ENV_KEY="${CUSTOMER_ID}-${CLUSTER_ID}"
#export PAX_APPROVER

#Add some helper tooling scripts to the user's path
export PATH="${APPLICATION_BIN}:${INFRASTRUCTURE_BIN}:${PROJECT_ROOT}/tooling/bin:${PATH}"

echo "Entering Shell"
# Open new interacive Bash setting up some conviences
exec /bin/bash --rcfile "${PROJECT_ROOT}/infrastructure/bin/lib/shell-config.bash" -i
