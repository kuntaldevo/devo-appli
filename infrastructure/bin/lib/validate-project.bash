# Load the required Customer Credetial Information.
# Typically at $CUSTOMTER_ID/aws.credentials
source "${INFRASTRUCTURE_BIN}/lib/get-customer-credentials.bash"

# Initialize the Distro, Infrastructure, The sizing and the approver
# While not completely necessary this will set some environment variables for some tags
# Get Customer's Cluster Shell configuration, This defines where everything else is found
source "${INFRASTRUCTURE_BIN}/lib/get-customer-cluster-config.bash"

### Validate there is a distro sub-folder available
if [[ ! -d "${PROJECT_ROOT}/infrastructure/cluster/distro/${DISTRO_ID}/" ]]; then
  echo "${ERROR}The required folder 'distro/${DISTRO_ID}' was not found."
  exit 2
fi
