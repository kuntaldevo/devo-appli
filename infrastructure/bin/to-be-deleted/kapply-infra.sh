#!/usr/bin/env bash
# B A S H ! ! !

#Apply STATIC yaml that has been checked into source control

# Capture if a param was passed and will be the action to kubectl
KUBECTL_WHAT="$1"

if [ -z "$KUBECTL_WHAT" ]; then
    KUBECTL_WHAT="apply"
fi


if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

source "${INFRASTRUCTURE_BIN}/lib/init-env-key.bash"

#Start Time
start_time=`date +%s`

echo "${FYI} Start Time: `date`"


APPLY_PATH="${PROJECT_ROOT}/infrastructure/kubernetes/${ENV_KEY}/app-infra"

if [[ ! -d "${APPLY_PATH}" ]]; then

  echo "\n${ERROR} Terraform returned exit code ${EXIT_CODE}. Error messages should have been provided.\n"

  EXIT_CODE="77"

else
  kubectl "${KUBECTL_WHAT}" -f "${APPLY_PATH}"
  EXIT_CODE="$?"
fi

end_time=`date +%s`

deltatime=$(( end_time - start_time ))
minutes=$(( deltatime / 60 ))
seconds=$(( deltatime % 60 ))

echo "$FYI End Time: `date`"
printf "$FYI Time spent: %02d:%02d\n" $minutes $seconds

if [[ "${EXIT_CODE}" != "0" ]]; then

  echo "\n${ERROR} Kubectl returned exit code ${EXIT_CODE}. Error messages should have been provided.\n"

  exit $EXIT_CODE
fi
