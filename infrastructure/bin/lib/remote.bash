#!/usr/bin/env bash
# B A S H ! ! !


error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}
trap 'error ${LINENO}' ERR


function get_kubernetes_config {

  local CLUSTER_NAME="$CUSTOMER_ID-$CLUSTER_ID"

  K_CMD="aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION_ID"

  eval "${K_CMD}"
}

function do_up {

  eval remote-up.sh --auto-approve
  REMOTE_RESULT=$?

  if [[ "${REMOTE_RESULT}" != "0" ]]; then

    echo "${ERROR} Terraform returned exit code ${EXIT_CODE}. Error messages should have been provided."

    return $REMOTE_RESULT
  fi

  eval ./bin/kustom-infra.sh apply

}

function do_down {

# Make sure we are pointing to the correct EKS Cluster
  get_kubernetes_config
  K_CONFIG_RESULT=$?

#IF getting the K8s config was sucessful then it must still exist and might need to be un-kustomized
  if [[ $K_CONFIG_RESULT == "0" ]]; then
    eval ./bin/kustom-infra.sh delete
  fi

# Try Terraform it down now
  eval remote-down.sh
  REMOTE_RESULT=$?

}

function bail() {
    cat << EOF
usage: $0 [options] [up | down]

Options:
-h: print help message and exit
-r <region>: use the given aws region (e.g. us-east-1) instead of the default "us-west-2"
-d: enable debugt logging for teraform

EOF
echo $1
exit 1
}

###
### End Functions
###

# Set the Approver Email to be the git email
export PAX_APPROVER=`git config user.email`


# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

# Get the Account Id, some scripts require Dev and Some Prod make this clear
source "${PROJECT_ROOT}/tooling/bin/lib/get-aws-account-id.bash"

if [[ "${ACCOUNT_ID}" != "$REQUIRED_ACCOUNT_ID" ]]; then

  echo "${ERROR} You are authenticated against the wrong account."

  exit 88
fi

POSITIONAL_ARGS=""
while [ $# -gt 0 ]; do
    while getopts "hdr:" arg; do
        case "$arg" in
            h)
                bail
                ;;
            d)
                DEBUG="TF_LOG=DEBUG"
                ;;
            r)
                REGION_ID="$OPTARG"
                ;;
        esac
    done
    shift $((OPTIND-1))
    POSITIONAL_ARGS="${POSITIONAL_ARGS}$1"
    shift || true
done

### The Validate there is a Customer is set
if [[ -z "$CUSTOMER_ID" ]]; then
  echo "CUSTOMER_ID required. Please check 'git config user.email' "
  exit 2
fi

### The Validate there is a Cluster is set
if [[ -z "$CLUSTER_ID" ]]; then
  echo "CLUSTER_ID required."
  exit 2
fi

### The Validate there is a Provider is set
if [[ -z "$PROVIDER_ID" ]]; then
  echo "PROVIDER_ID required."
  exit 2
fi

### The Validate there is a Region is set
if [[ -z "$REGION_ID" ]]; then
  echo "REGION_ID required."
  exit 2
fi

# Determine whether we're starting or stopping the cluster
COMMAND=""
case "$POSITIONAL_ARGS" in
    "up")
        COMMAND="remote-up.sh --auto-approve"
        ;;
    "down")
        COMMAND="remote-down.sh"
        ;;
    "config")
      get_kubernetes_config
      K_CONFIG_RESULT=$?
        ;;
    *)
        bail "Must supply a command of either 'up' or 'down'"
        ;;
esac

echo "executing: '$COMMAND' with region: '$REGION_ID'"

# Define bin location path env variable
export INFRASTRUCTURE_BIN="${PROJECT_ROOT}/infrastructure/bin"

# At this momment no need to validate the Customer or the Customer/Cluster, ie the developer.
#TODO in the future create a mechanism to allow developers to set their own settings

# Validate Provider Authenticated
source "${PROJECT_ROOT}/tooling/bin/validate-${PROVIDER_ID}-auth.sh" "saml2aws"

#Set the shell with the values passed in
#NOTE TODO, This location to set ENV-KEY should be unnecessary
export ENV_KEY="${CUSTOMER_ID}-${CLUSTER_ID}"

#TODO, Not sure what this is for
export PROFILE_ID

#Add some helper tooling scripts to the user's path
export PATH="${INFRASTRUCTURE_BIN}:${PROJECT_ROOT}/tooling/bin:${PATH}"

source "${PROJECT_ROOT}/infrastructure/bin/lib/shell-config.bash"

case "$POSITIONAL_ARGS" in
    "up")
        do_up
        ;;
    "down")
        do_down
        ;;
esac
