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

if [ -z "$REGION_ID" ]; then
    echo "Required Env Var REGION_ID is missing."
    exit 1
fi

source "${INFRASTRUCTURE_BIN}/lib/init-env-key.bash"


# Validate Provider Authenticated
source "${PROJECT_ROOT}/tooling/bin/validate-${PROVIDER_ID}-auth.sh"

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

#These validations here becuase I have env_key vars etc

# Validate the bucket doesn't already exist
source "${PROJECT_ROOT}/tooling/bin/validate-tfstate-bucket.sh"
# Validate the Dynamo DB tables doesn't already exist
source "${PROJECT_ROOT}/tooling/bin/validate-tfstate-lock.sh"

echo "Terraform Params: $TF_PARAMS"

pushd "${PROJECT_ROOT}/infrastructure/${PROVIDER_ID}/remote-init"

terraform init -input=false

eval "terraform apply $TF_PARAMS"
EXIT_CODE="$?"

# Because this init is simple and the state can not be stored remotely, we will roll back automatically on error.
if [[ "${EXIT_CODE}" != "0" ]]; then

  echo "${ERROR} Terraform returned exit code ${EXIT_CODE}. Error messages should have been provided."
  echo "${ERROR} Automatically rolling back any completed infrastructure."
  eval "terraform destroy --force $TF_PARAMS"
  EXIT_CODE="$?"

  # Produce a message on second error and tell the user 'good luck'
  if [[ "${EXIT_CODE}" != "0" ]]; then

    echo "${ERROR} Terraform returned exit code ${EXIT_CODE}. Error messages should have been provided."
    echo "${ERROR} Contact Devops for assistance."
  fi
fi

# Try copying the remote state up, supress any output ( I think that's OK )
eval "aws s3 cp terraform.tfstate s3://${BUCKET_NAME}/remote-init.tfstate >/dev/null 2>&1"
EXIT_CODE="$?"

#If no error we will assume that everything was OK and we will delete the local terraform states
# Because this init is simple and the state can not be stored remotely, we will roll back automatically on error.
if [[ "${EXIT_CODE}" == "0" ]]; then

  eval "rm -rf .terraform"
  eval "rm -rf terraform.tfstate*"

fi

popd

deltatime=$(( end_time - start_time ))
minutes=$(( deltatime / 60 ))
seconds=$(( deltatime % 60 ))

echo "$FYI End Time: `date`"
printf "$FYI Time spent: %02d:%02d\n" $minutes $seconds
