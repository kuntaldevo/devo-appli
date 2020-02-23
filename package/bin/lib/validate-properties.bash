
# Get Customer's Credenitals to their cloud provider.
# File is an HCL format (terraform), and Packer must have JSON
CREDENTIALS_FILE="${PROJECT_ROOT}/application/customer/${CUSTOMER_ID}/${PROVIDER}.credentials"

if [[ ! -e "$CREDENTIALS_FILE" ]]; then
   echo "${ERROR}File $CREDENTIALS_FILE not found."
   exit 2
else
  source "$CREDENTIALS_FILE"
fi

# Get Shell Variables for a Distribution and Region
DISTRO_REGION_CONFIG="${PROJECT_ROOT}/application/distro/${DISTRO_ID}/package/${REGION_ID}.config"

if [[ ! -e "$DISTRO_REGION_CONFIG" ]]; then
   echo "${ERROR}File $DISTRO_REGION_CONFIG not found."
   exit 2
else
  source "$DISTRO_REGION_CONFIG"
fi

# Get Shell Variables for a Customer's Region
# Get any Customer / Region specific values.  This was initially for Packer to be able to build in a specific VPN and Subnet
CUSTOMER_REGION_CONFIG="${PROJECT_ROOT}/application/customer/${CUSTOMER_ID}/package/${REGION_ID}.config"

if [[ ! -e "$CUSTOMER_REGION_CONFIG" ]]; then
   echo "${FYI}File $CUSTOMER_REGION_CONFIG not found."
else
  source "$CUSTOMER_REGION_CONFIG"
fi
