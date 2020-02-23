#!/usr/bin/env bash
# B A S H ! ! !

# Validate that Init has been run

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

# Validate Provider Authenticated
exec "${PROJECT_ROOT}/tooling/bin/validate-${PROVIDER}-auth.sh"

# Get Shell Variables for a Distribution and Region
DISTRO_REGION_CONFIG="${PROJECT_ROOT}/application/distro/${DISTRO_ID}/package/${REGION_ID}/package.config"

if [[ ! -e "$DISTRO_REGION_CONFIG" ]]; then
   echo "${ERROR}File $DISTRO_REGION_CONFIG not found."
   exit 2
else
  echo "${FYI}Testing:  $DISTRO_REGION_CONFIG"
  source "$DISTRO_REGION_CONFIG"
fi

if [ -z "$ROOT_VMI" ]; then
    echo "${ERROR}The variable 'ROOT_VMI' must be set."
    exit 1
fi

if [ -z "$BASE_VMI" ]; then
    echo "${ERROR}The variable 'BASE_VMI' must be set."
    exit 2
fi

if [ -z "$BASE_SERVER_AMI" ]; then
    echo "${ERROR}The variable 'BASE_SERVER_AMI' must be set."
    exit 3
fi

aws ec2 describe-images --image-ids "$ROOT_VMI"  >/dev/null 2>&1
EXIT_CODE=$?

if [[ "${EXIT_CODE}" != "0" ]]; then

  echo "${ERROR} The ROOT VMI Id $ROOT_VMI was not found."
  exit "$EXIT_CODE"
fi

aws ec2 describe-images --image-ids "$BASE_VMI"  >/dev/null 2>&1
EXIT_CODE=$?

if [[ "${EXIT_CODE}" != "0" ]]; then

  echo "${ERROR} The BASE VMI Id $BASE_VMI was not found."
  exit "$EXIT_CODE"
fi

aws ec2 describe-images --image-ids "$BASE_SERVER_AMI"  >/dev/null 2>&1
EXIT_CODE=$?

if [[ "${EXIT_CODE}" != "0" ]]; then

  echo "${ERROR} The ROOT BASE SERVER Id $BASE_SERVER_AMI was not found."
  exit "$EXIT_CODE"
fi

echo "${VALID}OK"
exit 0
