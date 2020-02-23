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

source "${INFRASTRUCTURE_BIN}/lib/init-env-key.bash"

# Validate Provider Authenticated
source "${PROJECT_ROOT}/tooling/bin/validate-${PROVIDER_ID}-auth.sh"

if [ -z "$REGION_ID" ]; then
    echo "Required Env Var REGION_ID is missing."
    exit 1
fi

# Load the required Customer Credetial Information.
# Typically at $CUSTOMTER_ID/aws.credentials
source "${INFRASTRUCTURE_BIN}/lib/get-customer-credentials.bash"


# Initialize the Distro, Infrastructure, The sizing and the approver
# While not completely necessary this will set some environment variables for some tags
# Get Customer's Cluster Shell configuration, This defines where everything else is found
source "${INFRASTRUCTURE_BIN}/lib/get-customer-cluster-config.bash"


# Generate ENV Vars, mostly from Git
source "${PROJECT_ROOT}/tooling/bin/lib/get-local-vars.bash"

# Generate TF_PARAMS for the Remote Init process
source "${INFRASTRUCTURE_BIN}/lib/tf-params-init.bash"

echo "Terraform Params: $TF_PARAMS"

pushd "${PROJECT_ROOT}/infrastructure/${PROVIDER_ID}/remote-init"

# If there is not a .terraform directory then perform an 'init'
if [[ ! -d ".terraform" ]]; then
  eval "terraform init"
fi

# Check to see if the TF State is stored remotely. download it if it is
eval "aws s3 cp s3://${BUCKET_NAME}/remote-init.tfstate terraform.tfstate >/dev/null 2>&1"

eval "terraform destroy -force $TF_PARAMS"
exit_code="$?"

#TODO TF removed the remote config command, implement an alternative
#eval "terraform remote config -backend=S3 -backend-config='bucket=${ENV_KEY}.devops.paxata.com' -backend-config='key=tf-state/init-${ENV_KEY}.tfstate' -backend-config='region=${REGION_ID}' "

popd

#End Time
deltatime=$(( end_time - start_time ))
minutes=$(( deltatime / 60 ))
seconds=$(( deltatime % 60 ))

echo "$FYI End Time: `date`"
printf "$FYI Time spent: %02d:%02d\n" $minutes $seconds
