#!/usr/bin/env bash
# B A S H ! ! !

# Set base variables for terraform

#NOTE: This provides the base configuration for terraform to do its thing.

export TF_IN_AUTOMATION="true"

TF_VARS=""

#Cloud Provider Region, same var name for both Azure and AWS
#NOTE: Bash needs double quotes for string interpolation, Terraform command line -var MUST wrap with sinlge quote, and Double quote for the key-value
TF_VARS="${TF_VARS} -var=\"region-id=${REGION_ID}\""
TF_VARS="${TF_VARS} -var=\"account-id=${ACCOUNT_ID}\""

# ENV Key was moved to its own file because K8s needs it as well and TF might go away
if [[ -z "$ENV_KEY" ]]; then

  echo "$ERROR It appears the init-env-key script has not yet been run"
  echo "$ERROR Notify Devops!!!!!"
  return 999
fi

# Define env-key variable. Used to help name resources
TF_VARS="${TF_VARS} -var=\"env-key=${ENV_KEY}\""

# Set AWS Specific Credentialing Details
# If 'AWS_PROFILE' is set then override the property set from a file
if [[ "${PROVIDER_ID}" == "$AWS" ]]; then

  if [[ -n "${AWS_PROFILE}" ]]; then
    TF_VARS="${TF_VARS} -var=\"profile-id=${AWS_PROFILE}\""
  else
    TF_VARS="${TF_VARS} -var=\"profile-id=${PROFILE_ID}\""
  fi
fi
# Set Azure Specific Credentialing Details
if [[ "${PROVIDER_ID}" == "$AZURE" ]]; then
  TF_VARS="${TF_VARS} -var=\"subscription-id=${subscription_id}\""
  TF_VARS="${TF_VARS} -var=\"client-id=${client_id}\""
  TF_VARS="${TF_VARS} -var=\"client-secret=${client_secret}\""
  TF_VARS="${TF_VARS} -var=\"tenant-id=${tenant_id}\""
fi

# Put all of the not normally used or changed values for the tags into one big Map
TAG_MAP_VALUES="env-key=\"${ENV_KEY}\""
# Installation Id came later as a better suggestion than ENV-Key.  Default it here to the ENV Key
export INSTALLATION_ID="${ENV_KEY}"
TAG_MAP_VALUES="${TAG_MAP_VALUES}, installation-id=\"${ENV_KEY}\""

# Create the ENV_KEY as late as possible
if [[ -n "$STAGE_ID" ]]; then
  TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"stage-id\":\"${STAGE_ID}\""
fi

TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"region-id\":\"${REGION_ID}\""

TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"cluster-id\":\"${CLUSTER_ID}\""
TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"distro-id\":\"${DISTRO_ID}\""

TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"scm-branch\":\"${SCM_BRANCH}\""
TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"scm-sha\":\"${SCM_SHA}\""
TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"scm-user\":\"${SCM_USER}\""
TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"scm-email\":\"${SCM_EMAIL}\""

TAG_MAP_VALUES="${TAG_MAP_VALUES}, create-user=\"${CREATE_USER}\""
TAG_MAP_VALUES="${TAG_MAP_VALUES}, create-timestamp=\"${CREATE_TIMESTAMP}\""
TAG_MAP_VALUES="${TAG_MAP_VALUES}, create-host=\"${CREATE_HOST}\""

TAG_MAP_VALUES="${TAG_MAP_VALUES}, user-id=\"${USER_ID}\""
TAG_MAP_VALUES="${TAG_MAP_VALUES}, user-role=\"${USER_ROLE}\""

### OK so these are not used by remote init, but since they use TF vars I put them here ( for now )
if [[ -z "$APPROVER_EMAIL" ]]; then
  APPROVER_EMAIL="$SCM_EMAIL"
fi

TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"approver-email\":\"${APPROVER_EMAIL}\""

### OK so these are not used by remote init, but since they use TF vars I put them here ( for now )
if [[ -n "$APPROVER_NAME" ]]; then
  TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"approver-name\":\"${APPROVER_NAME}\""
fi

TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"expiration-date\":\"${EXPIRATION_DATE}\""
TAG_MAP_VALUES="${TAG_MAP_VALUES}, \"tf-config\":\"${INFRASTRUCTURE_ID}\""

# Create a Map of the rest of the Tags
TAG_MAP="tag-map={${TAG_MAP_VALUES}}"

# Append TAG_MAP to TF_VARS
TF_VARS="${TF_VARS} -var='${TAG_MAP}'"

### OK so these are not used by remote init, but since they use TF vars I put them here ( for now )
if [[ -n "$WFH" ]]; then
  source "${INFRASTRUCTURE_BIN}/lib/get-wfh.bash"
  TF_VARS="${TF_VARS} -var=\"wfh-ip=${IP_WFH}"
fi

###
# Get Properties that are set at the customer level (typical) to get credentialing

VAR_FILES=""

### Get Account Specific Settings like IAM Roles, that are global across ALL regions
if [[ -n "$DEVELOPER" ]]; then
  ACCOUNT_PROPERTIES="${PROJECT_ROOT}/application/customer/paxata/${ACCOUNT_ID}.properties"
else
  ACCOUNT_PROPERTIES="${PROJECT_ROOT}/application/customer/${CUSTOMER_ID}/${ACCOUNT_ID}.properties"
fi


if [[ -f "$ACCOUNT_PROPERTIES" ]]; then
   VAR_FILES="$VAR_FILES -var-file=$ACCOUNT_PROPERTIES"
else
   echo "${FYI}Account Properties: $ACCOUNT_PROPERTIES does not exist."
fi


#Common properties a Customer might have for all of their clusters and regions, Like Whitelist IPs
if [[ -n "$DEVELOPER" ]]; then
  CUSTOMER_PROPERTIES="${PROJECT_ROOT}/application/customer/paxata/customer.properties"
else
  CUSTOMER_PROPERTIES="${PROJECT_ROOT}/application/customer/${CUSTOMER_ID}/customer.properties"
fi


if [[ -f "$CUSTOMER_PROPERTIES" ]]; then
   VAR_FILES="$VAR_FILES -var-file=$CUSTOMER_PROPERTIES"
else
   echo "${FYI}Customer Properties: $CUSTOMER_PROPERTIES does not exist."
fi

export TF_PARAMS="$TF_VARS $VAR_FILES"

export BUCKET_NAME="tfstate.${ENV_KEY}.${REGION_ID}.devops.paxata.com"
