# Make sure that the folders all are available that map from passed in parameters into init.sh

### The Validate there is a matching distro sub-folder is set
if [[ ! -d "${PROJECT_ROOT}/application/distro/${DISTRO_ID}/" ]]; then
  echo "${ERROR}The required folder 'distro/${DISTRO_ID}' was not found."
  exit 2
fi

### The Validate there is a matching packaging config file
if [[ ! -f "${PROJECT_ROOT}/application/distro/${DISTRO_ID}/package/${REGION_ID}.config" ]]; then
  echo "${ERROR}The required file '${REGION_ID}.config' for 'distro/${DISTRO_ID}/package' was not found."
  exit 2
fi
