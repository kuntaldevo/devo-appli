#!/usr/bin/env bash
# B A S H ! ! !

#Create a Customer's Cluster

# Creates ENV Var TF_VARS & VAR_FILES to be passed to Terraform
source "${INFRASTRUCTURE_BIN}/lib/tf-params-init.bash"

###
# For the Var Files the order matters
# Ordered from a broader definition to a more specific ( region specific )
###

#NOTE: Two var files are also used by Init to get Cloud Provider Credentials that are usually customer specific

VAR_FILES=""
if [[ -n "${DISTRO_ID}" ]]; then

  # The VMI IDs (ie AWS AMI) to be instantiated. A Specific Distribution's Region.
  VMI_VAR_FILE="${PROJECT_ROOT}/infrastructure/cluster/distro/${DISTRO_ID}/${REGION_ID}.vmi.properties"

  if [[ -f "$VMI_VAR_FILE" ]]; then
     VAR_FILES="$VAR_FILES -var-file=$VMI_VAR_FILE"
  else
     echo "${WARNING}VMI: $VMI_VAR_FILE does not exist."
  fi

else
  echo "${FYI}No Distro Id set in /infrastructure/cluster/${CUSTOMER_ID}/${CLUSTER_ID}/cluster.properites"
fi

if [[ -n "${ISIZE_ID}" ]]; then

  # Common / Standard server sizings ( Instance Type, Volume Size, Memory )
  SIZING_PROPERTIES="${PROJECT_ROOT}/infrastructure/cluster/isize/${ISIZE_ID}/${PROVIDER_ID}.properties"

  if [[ -f "$SIZING_PROPERTIES" ]]; then
     VAR_FILES="$VAR_FILES -var-file=$SIZING_PROPERTIES"
  else
     echo "${ERROR}Sizing: $SIZING_PROPERTIES does not exist.${NC}"
     exit 4
  fi

else
  echo "${FYI}No I-Size Id set in /infrastructure/cluster/${CUSTOMER_ID}/${CLUSTER_ID}/cluster.properites"
fi
#TODO?  Create Region Specific Properties for infrastructure ?

#Customer's properties might have for a specific region, Like Region Specific Security Keys
if [[ -n "$DEVELOPER" ]]; then
  CUST_REGION_PROPERTIES="${PROJECT_ROOT}/infrastructure/cluster/paxata/region/${REGION_ID}.properties"
else
  CUST_REGION_PROPERTIES="${PROJECT_ROOT}/infrastructure/cluster/${CUSTOMER_ID}/region/${REGION_ID}.properties"
fi

if [[ -f "$CUST_REGION_PROPERTIES" ]]; then
   VAR_FILES="$VAR_FILES -var-file=$CUST_REGION_PROPERTIES"
else
   echo "${WARNING}Customer Region Specific: $CUST_REGION_PROPERTIES does not exist."
fi

# Any Customer / Cluster / Provider Specific Properties, Assuming Clusters don't change in various regions
if [[ -n "$DEVELOPER" ]]; then
  CUST_CLUSTER_PROPERTIES="${PROJECT_ROOT}/infrastructure/cluster/paxata/${CLUSTER_ID}/cluster.properties"
else
  CUST_CLUSTER_PROPERTIES="${PROJECT_ROOT}/infrastructure/cluster/${CUSTOMER_ID}/${CLUSTER_ID}/cluster.properties"
fi

if [[ -f "$CUST_CLUSTER_PROPERTIES" ]]; then
   VAR_FILES="$VAR_FILES -var-file=$CUST_CLUSTER_PROPERTIES"
else
   echo "${WARNING}Customer Cluster: $CUST_CLUSTER_PROPERTIES does not exist."
fi

# Any Customer / Cluster / Provider Specific Properties, Assuming Clusters don't change in various regions
if [[ -n "$DEVELOPER" ]]; then
  CUST_CLUSTER_REGION_PROPERTIES="${PROJECT_ROOT}/infrastructure/cluster/paxata/${CLUSTER_ID}/region/${REGION_ID}.properties"
else
  CUST_CLUSTER_REGION_PROPERTIES="${PROJECT_ROOT}/infrastructure/cluster/${CUSTOMER_ID}/${CLUSTER_ID}/region/${REGION_ID}.properties"
fi

### Cluster specific properites are pretty rare these days so no FYI needed.
if [[ -f "$CUST_CLUSTER_REGION_PROPERTIES" ]]; then
   VAR_FILES="$VAR_FILES -var-file=$CUST_CLUSTER_REGION_PROPERTIES"
fi

if [[ -n "${STAGE_ID}" ]]; then

  STAGE_PROPERTIES="${PROJECT_ROOT}/infrastructure/cluster/paxata/${CLUSTER_ID}/${STAGE_ID}/stage.properties"

  if [[ -f "$STAGE_PROPERTIES" ]]; then
     VAR_FILES="$VAR_FILES -var-file=$STAGE_PROPERTIES"
  else
     echo "${FYI}Stage: $STAGE_PROPERTIES does not exist."
  fi

else
  echo "${FYI}Stage Flag not found.  Skipping."
fi


# Any Region specific Provider Properties, If it needs to be overridden then the property doesn't belong in here in the first place
REGION_PROVIDER_PROPERTIES="${PROJECT_ROOT}/provider/${PROVIDER_ID}/region/${REGION_ID}.properties"

if [[ -f "$REGION_PROVIDER_PROPERTIES" ]]; then
   VAR_FILES="$VAR_FILES -var-file=$REGION_PROVIDER_PROPERTIES"
else
   echo "${WARNING}Provider Region: $REGION_PROVIDER_PROPERTIES does not exist."
fi

# Any Provider Instance Type Properties
REGION_PROVIDER_PROPERTIES="${PROJECT_ROOT}/provider/${PROVIDER_ID}/instance-type.properties"

if [[ -f "$REGION_PROVIDER_PROPERTIES" ]]; then
   VAR_FILES="$VAR_FILES -var-file=$REGION_PROVIDER_PROPERTIES"
else
   echo "${WARNING}Region: $REGION_PROVIDER_PROPERTIES does not exist."
fi

export TF_PARAMS="${TF_PARAMS} ${VAR_FILES}"
