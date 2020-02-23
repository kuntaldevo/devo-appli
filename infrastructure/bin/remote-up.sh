#!/usr/bin/env bash
# B A S H ! ! !

#remote-up.sh --tf "init --upgrade"

# Validate that Init has been run

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

#Start Time
start_time=`date +%s`

echo "${FYI} Start Time: `date`"

source "${INFRASTRUCTURE_BIN}/lib/init-env-key.bash"

source "${INFRASTRUCTURE_BIN}/lib/validate-env.bash"

# Init variable for optional Target Parameter
TARGET=""

### Begin getopt setup
OPTIONS=h
LONGOPTIONS=wfh,help,debug,tf:,auto-approve

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
      --wfh)
            WFH=true
            shift
            ;;
      --auto-approve)
            AUTO_APPROVE="-auto-approve"
            shift
            ;;
      --debug)
            DEBUG="TF_LOG=DEBUG"
            shift
            ;;
      --tf)
          TF="$2"
          shift
          break
          ;;
      *)
      # If a second param was passed in then we will want to override the directory that TF is going to use
      # and will apply the TF_DIR infra over the Origional Infrastructure Id
      # Don't override the infrastructure ID yet because we have not even loaded the inital infrastructure Id
      TF_DIR="$2"
      shift
      break
      ;;
  esac
done
### End getopt

# Validate Provider Authenticated
source "${PROJECT_ROOT}/tooling/bin/validate-${PROVIDER_ID}-auth.sh"


source "${INFRASTRUCTURE_BIN}/lib/validate-project.bash"

# Get GIT and Shell ENV vars. This is warming up to create the tag-map
source "${PROJECT_ROOT}/tooling/bin/lib/get-local-vars.bash"

#Create TF_PARAMS, the parameters that will be passed to Terraform
# This needs to be run after the local vars
source "${INFRASTRUCTURE_BIN}/lib/tf-params-up.bash"


# Run pre-terraform hook
# pass in 'up'
#
# source post-terraform.bash UP $EXIT_CODE
# EXIT_CODE=$?
echo "$FYI Running pre-terraform"
source "${INFRASTRUCTURE_BIN}/lib/pre-terraform.bash" "up"
EXIT_CODE="$?"

echo "Terraform Params: $TF_PARAMS"

echo "$FYI Running Terraform"
source "${INFRASTRUCTURE_BIN}/lib/terraform.bash"
EXIT_CODE="$?"


echo "$FYI Running post-terraform"
source "${INFRASTRUCTURE_BIN}/lib/post-terraform.bash"  "up" "$EXIT_CODE"
EXIT_CODE="$?"

# Run post-terraform hook
# pass in 'up'and the EXIT_CODE from terraform
#
# source post-terraform.bash UP $EXIT_CODE
# EXIT_CODE=$?

#TODO? Generate a tag to mark the existing version of the ENV_KEY in use
# git tag "${ENV_KEY}" -m "Tag for existing deployment"

end_time=`date +%s`

deltatime=$(( end_time - start_time ))
minutes=$(( deltatime / 60 ))
seconds=$(( deltatime % 60 ))

echo "$FYI End Time: `date`"
printf "$FYI Time spent: %02d:%02d\n" $minutes $seconds

#echo "--- The Return Value was: ${EXIT_CODE}"

if [[ "${EXIT_CODE}" != "0" ]]; then

  echo "\n${ERROR} Terraform returned exit code ${EXIT_CODE}. Error messages should have been provided.\n"

  exit $EXIT_CODE
fi
