#!/usr/bin/env bash
# B A S H ! ! !

#Start Time
start_time=`date +%s`

# Validate that Init has been run

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi


# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

# Validate Provider Authenticated
source "${PROJECT_ROOT}/tooling/bin/validate-${PROVIDER}-auth.sh"

source "${PACKAGE_BIN}/lib/validate.bash"

TARGET="$1"

shift

DEBUG=""

#See if Debug was passed in as the second var
if [[ "${TARGET}" == "--debug" ]]; then
   DEBUG="-debug"

   echo "${FYI}Debug flag found."

  TARGET="$1"

  # shift to get the actual target
  shift

fi

WHAT=""
#See if custom what
if [[ "$TARGET" == "custom" ]]; then
   WHAT="$1"

   echo "${FYI}Custom Target:  ${WHAT}"

fi

### Check for another param that would be a playbook override
export ANSIBLE_PLAYBOOK="$TARGET"
echo
if [[ $# -eq 1 ]]; then
  export ANSIBLE_PLAYBOOK="$1"

  echo "${FYI}Playbook Override:  ${ANSIBLE_PLAYBOOK}"
else
  echo "${FYI}Playbook:  ${ANSIBLE_PLAYBOOK}"
fi

# Set Azure Specific Environment vars
# using the -var doesn't seem to work
if [[ "${PROVIDER}" == "$AZURE" ]]; then
   export image_store_id="vmi-${DISTRO_ID}"
fi

WORK_DIR="$TARGET/"


if [[ "custom" = $TARGET* ]]; then

  WORK_DIR="custom-server"

  source "${WORK_DIR}/config/${WHAT}.settings"

fi

source "${PROJECT_ROOT}/tooling/bin/lib/get-local-vars.bash"

# Environment variable to set a path that will be used as the ansible host_vars
# Setup the provisioner paths
source "${PACKAGE_BIN}/lib/get-host-vars.bash"

pushd "$WORK_DIR/"

eval packer build ${DEBUG} ${PROVIDER}.json

popd

end_time=`date +%s`

deltatime=$(( end_time - start_time ))
minutes=$(( deltatime / 60 ))
seconds=$(( deltatime % 60 ))

echo "$FYI End Time: `date`"
printf "$FYI Time spent: %02d:%02d\n" $minutes $seconds
