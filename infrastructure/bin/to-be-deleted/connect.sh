#!/usr/bin/env bash
# B A S H ! ! !

# Validate that Init has been run

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

if [ -z "$REGION_ID" ]; then
    echo "Required Env Var REGION_ID is missing."
    exit 1
fi

# Validate Provider Authenticated
source "${PROJECT_ROOT}/tooling/bin/validate-${PROVIDER_ID}-auth.sh"

# Get Customer's provider specific credentials
# These are in Bash because the credentials are used by multiple tools.
# Terraform wants these in HCL
# Packer wants these in JSON
CUST_PROVIDER_CREDS="${PROJECT_ROOT}/application/customer/${CUSTOMER_ID}/${PROVIDER_ID}.credentials"

if [[ -f "${CUST_PROVIDER_CREDS}" ]]; then
   source "${CUST_PROVIDER_CREDS}"
else
   echo "${ERROR}${CUST_PROVIDER_CREDS} does not exist.${NC}"
   exit 4
fi


# Generate ENV Vars, mostly from Git
source "${PROJECT_ROOT}/tooling/bin/lib/get-local-vars.bash"

# Generate TF_PARAMS for the Remote Init process
source "${INFRASTRUCTURE_BIN}/lib/tf-params-init.bash"

ssh -i ~/.ssh/"$aws-key-pair" centos@"proxy-$ENV_KEY.paxatadev.com"
