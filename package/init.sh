#!/usr/bin/env bash
# B A S H ! ! !

#Define Defaults
export PROVIDER='aws'

#Customer Id is used to find the credentials to use to access the provider
export CUSTOMER_ID='paxata'

# Set and environment variable that allows other scripts to know the main relative context
# Only relative path we will code for.  Once we have the project_root we can priarily use full paths
source "../tooling/project-root.sh"
export PROJECT_ROOT

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

# Define bin location path env variable
export PACKAGE_BIN="${PROJECT_ROOT}/package/bin"


###
# Validate GetOpt is of correct version, if Mac see Wiki Devops Onboarding
getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
  echo "${ERROR}The Latest version of GetOpt is required."
  echo "${ERROR}If Mac see Wiki Devops Onboarding."
  exit 1
fi

OPTIONS=h
LONGOPTIONS=provider:,distro:,region:

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
        --provider)
            PROVIDER_ARG="$2"
            shift
            shift
            ;;
        --distro)
            DISTRO_ARG="$2"
            shift
            shift
            ;;
        --region)
          REGION_ARG="$2"
          shift
          shift
          ;;
        *)
            break
            ;;
    esac
done

#Set the shell with the values passed in
### The provider arg will override the provider in the Shell
if [[ -n "$PROVIDER_ARG" ]]; then
  export PROVIDER="${PROVIDER_ARG}"
fi

### The Region arg will override the REGION_ID in the Shell
if [[ -n "$REGION_ARG" ]]; then
  export REGION_ID="${REGION_ARG}"
fi

### The Distro arg will override the DISTRO_ID in the Shell
if [[ -n "$DISTRO_ARG" ]]; then
  export DISTRO_ID="${DISTRO_ARG}"
fi

###
### Validate all pre-req env vars are set
###

### The Validate there is a distro_id is set
if [[ -z "$DISTRO_ID" ]]; then
  echo "flag --distro required."
  exit 2
fi

### The Validate there is a REGION_ID is set
if [[ -z "$REGION_ID" ]]; then
  echo "flag --region required."
  exit 2
fi

# Because we use the "Default" profile for AWS authentication, if the Profile's region is set then it might cause some
# Unexpected behaviour.  Therefore we will set the AWS Environment Variable to override it.  That way if you
# run any AWS CLI commands ( or scripts that rely on aws cli ) they will automatically be run in the same region as you ran init.sh with
export AWS_DEFAULT_REGION="${REGION_ID}"


source "${PACKAGE_BIN}/lib/validate-init.bash"

#? Do I need to use a Pax Approver for packaging?  Probably NOT.
export PAX_APPROVER

#Add some helper tooling scripts to the user's path
export PATH="${PACKAGE_BIN}:${PROJECT_ROOT}/tooling/bin:${PATH}"

echo "Entering Shell"
# Open new interacive Bash setting up some conviences
exec /bin/bash --rcfile "${PACKAGE_BIN}/lib/shell-config.bash" -i
