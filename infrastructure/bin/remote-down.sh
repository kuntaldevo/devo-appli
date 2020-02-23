#!/usr/bin/env bash
# B A S H ! ! !

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

source "${INFRASTRUCTURE_BIN}/lib/init-env-key.bash"

# Validate Provider Authenticated
source "${PROJECT_ROOT}/tooling/bin/validate-${PROVIDER_ID}-auth.sh"

#Start Time
start_time=`date +%s`

echo "$FYI Start Time: `date`"

# Init variable for optional TF_DIR Parameter
#This is the Dir that will be used instead of the one in the INFRASTRUCTURE_ID
TF_DIR=""

### Begin getopt setup
OPTIONS=h
LONGOPTIONS=help,debug

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

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
      --debug)
              DEBUG="TF_LOG=DEBUG"
              shift
              ;;
      *)
            TF_DIR="$2"
            shift
            break
            ;;
    esac
done
### End getopt

# Load the required Customer Credetial Information.
# Typically at $CUSTOMTER_ID/aws.credentials
source "${INFRASTRUCTURE_BIN}/lib/get-customer-credentials.bash"

# Initialize the Distro, Infrastructure, The sizing and the approver
# While not completely necessary this will set some environment variables for some tags
# Get Customer's Cluster Shell configuration, This defines where everything else is found
source "${INFRASTRUCTURE_BIN}/lib/get-customer-cluster-config.bash"

###
# Validate required Env Vars exist
if [ -z "$REGION_ID" ]; then
    echo "Required Env Var REGION_ID is missing."
    exit 1
fi

source "${PROJECT_ROOT}/tooling/bin/lib/get-local-vars.bash"

#Create TF_PARAMS, the parameters that will be passed to Terraform
# This needs to be run after the local vars
source "${INFRASTRUCTURE_BIN}/lib/tf-params-up.bash"

echo "Terraform Params: $TF_PARAMS"

if [[ -z "$TF_DIR" ]]; then
  pushd "${PROJECT_ROOT}/infrastructure/${PROVIDER_ID}/${INFRASTRUCTURE_ID}"
else
  pushd "${PROJECT_ROOT}/infrastructure/${PROVIDER_ID}/${TF_DIR}"
fi

#Generate the Backend.tf
source "${INFRASTRUCTURE_BIN}/lib/${PROVIDER_ID}/terraform-remote-config.bash"

# See:  https://github.com/hashicorp/terraform/issues/17862
export TF_WARN_OUTPUT_ERRORS=1

eval "${DEBUG} terraform destroy -force ${TF_PARAMS}"

EXIT_CODE=$?

popd

end_time=`date +%s`

deltatime=$(( end_time - start_time ))
minutes=$(( deltatime / 60 ))
seconds=$(( deltatime % 60 ))

echo "$FYI End Time: `date`"
printf "$FYI Time spent: %02d:%02d\n" $minutes $seconds

if [[ "${EXIT_CODE}" != "0" ]]; then

  echo "\n${ERROR} Terraform returned exit code ${EXIT_CODE}. Error messages should have been provided.\n"

  exit $EXIT_CODE
fi
