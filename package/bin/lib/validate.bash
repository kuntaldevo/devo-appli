
# Perform a Littany of Validations to prepare for packaging

#  Additionally may ( will ) setup some variables that are optional

# Import the Version compare utility
source "${PROJECT_ROOT}/tooling/bin/lib/version-compare.bash"



# Validate we have Packer is available

source "${PACKAGE_BIN}/lib/validate-packer.bash"

# Validate Certain properties files are available

source "${PACKAGE_BIN}/lib/validate-properties.bash"
