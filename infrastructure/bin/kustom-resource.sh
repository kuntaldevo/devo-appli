#!/usr/bin/env bash
# B A S H ! ! !

# Kustomize a single resource and apply it to the current K8s cluster

if [ -z "$PROJECT_ROOT" ]; then
  echo "Error:  No Project Root set.  Trying to find it."
  source "../tooling/project-root.sh"
  export PROJECT_ROOT
fi

if [ -z "$ACCOUNT_ID" ]; then
  echo "Error:  No Account ID set.  Trying to find it."
  source "../tooling/bin/lib/get-aws-account-id.bash"
  export ACCOUNT_ID
fi


export WORK_DIR="${PROJECT_ROOT}/infrastructure/kustomize/.workdir"
mkdir -p $WORK_DIR

# Capture if a param was passed and will be the action to kubectl
KUSTOM_WHAT="$1"

# Capture if a param was passed and will be the action to kubectl
KUBECTL_WHAT="$2"

if [ -z "$KUSTOM_WHAT" ]; then
    echo "Error:  Resource name is required."
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

#Start Time
start_time=`date +%s`

echo "${FYI} Start Time: `date`"

source "${PROJECT_ROOT}/infrastructure/bin/lib/init-env-key.bash"

# Get GIT and Shell ENV vars. This is warming up to create the tag-map
source "${PROJECT_ROOT}/tooling/bin/lib/get-local-vars.bash"

# There might be a specific Cluster Name pre-set that will be the one that kustomize should use.  This is the case as in for developer-eks.sh
# Otherwise we default to the ENV_KEY which is typical
if [[ -z ${CLUSTER_NAME} ]]; then
  CLUSTER_NAME="${ENV_KEY}"
fi

###  IF the cluster name is still blank then get the current context cluster name
if [[ -z ${CLUSTER_NAME} ]]; then
  source "${PROJECT_ROOT}/infrastructure/bin/lib/get-kubernetes-context.bash"
  CLUSTER_NAME="$CURRENT_KUBERNETES_CONTEXT"
fi

###  IF the cluster name is still blank then throw an error
if [[ -z ${CLUSTER_NAME} ]]; then

  echo "${ERROR} Unable to find a CLUSTER-NAME"
  exit 76
fi

echo "$FYI Cluster is $CLUSTER_NAME"


###  IF the Region is Missing, use the K8s context (a AWS arn )
if [[ -z ${REGION_ID} ]]; then
  source "${PROJECT_ROOT}/infrastructure/bin/lib/get-kubernetes-context.bash"
  REGION_ID="$CURRENT_KUBERNETES_REGION"
fi

echo "$FYI Region is $REGION_ID"

# The directory we are going to sync into the workdir
SOURCE_PATH="${PROJECT_ROOT}/infrastructure/kustomize/resource/${KUSTOM_WHAT}"

if [[ ! -d "${SOURCE_PATH}" ]]; then

  echo "${ERROR} Unable to find working dir: ${SOURCE_PATH}"

  exit 77

fi


RM_CMD="rm -rf ${WORK_DIR}/*"
eval $RM_CMD

CP_CMD="cp -a ${SOURCE_PATH}/* ${WORK_DIR}/"
eval $CP_CMD

# Make the destination Dir available for pre as there is some yaml generated too
# Using ENV key instead, we need the full name of the EKS cluster
export DESTINATION_DIR="${PROJECT_ROOT}/infrastructure/kubernetes/${CLUSTER_NAME}"

mkdir -p "$DESTINATION_DIR"
source "${PROJECT_ROOT}/infrastructure/kustomize/pre-kustomize.bash"


### IF the resource has a pre-kustomize.bash file source it as well...
if [[ -f "${SOURCE_PATH}/pre-kustomize.bash" ]]; then

  echo "FOUND:  ${SOURCE_PATH}/pre-kustomize.bash"

  source "${SOURCE_PATH}/pre-kustomize.bash"
else
  echo "NOT FOUND:  ${SOURCE_PATH}/pre-kustomize.bash"
fi


CREATION_DATE=$(date +%Y-%m-%dT%H:%M:%S%z)
DONT_EDIT=$(cat <<EOF
###
### DO NOT EDIT.  FILE GENERATED BY KUSTOMIZE
### ${CREATION_DATE}
EOF
)

###  Add some alaises because I get confused at times.
if [[ "$KUBECTL_WHAT" == "up" ]]; then
  KUBECTL_WHAT="apply"
elif  [[ "$KUBECTL_WHAT" == "down" ]]; then
  KUBECTL_WHAT="delete"
fi

if  [[ "$KUBECTL_WHAT" == "delete" ]]; then
  KUBECTL_OPTION="--ignore-not-found=true --force=true --grace-period=0"
fi

DEST_FILE="$DESTINATION_DIR/$KUSTOM_WHAT.yaml"

# if apply was actually specified then write the YAML to disk and apply it
if [[ "$KUBECTL_WHAT" == "write" ]]; then

  kustomize build "${WORK_DIR}/" | (echo "$DONT_EDIT" && cat) > "$DEST_FILE"

elif [[ -n "$KUBECTL_WHAT" ]]; then

  kustomize build "${WORK_DIR}/" | (echo "$DONT_EDIT" && cat) > "$DEST_FILE"

  K_CMD="kubectl $KUBECTL_WHAT ${KUBECTL_OPTION} -f  $DEST_FILE"

  eval "${K_CMD}"

else # just output to STD out
  kustomize build "${WORK_DIR}/"
fi


end_time=`date +%s`

deltatime=$(( end_time - start_time ))
minutes=$(( deltatime / 60 ))
seconds=$(( deltatime % 60 ))

echo "$FYI End Time: `date`"
printf "$FYI Time spent: %02d:%02d\n" $minutes $seconds

if [[ "${EXIT_CODE}" > "0" ]]; then

  echo "\n${ERROR} Kubectl returned exit code ${EXIT_CODE}. Error messages should have been provided.\n"

  exit $EXIT_CODE
fi
