
# Validate that packer is on the $PATH

WHICH_PACKER=`command -v packer`

# Check the packer file exists
if ! [[ -f "${WHICH_PACKER}" ]]; then
  echo '${ERROR}Packer was not found in your $PATH.' >&2
  exit 1
fi

#Check to make sure packer is executable
if ! [[ -x "${WHICH_PACKER}" ]]; then
  echo '${ERROR}Packer is not executable. ' >&2
  exit 1
fi

# Check the Version of packer

WHICH_PACKER=`packer --version`

REQUIRED_PACKER="1.2.1"

PACKER_COMPARE=`vercomp ${WHICH_PACKER} ${REQUIRED_PACKER}`

if [[ "${PACKER_COMPARE}" -lt 0 ]]; then
  echo "${ERROR}Packer must be version ${REQUIRED_PACKER}.  Your version ${WHICH_PACKER} " >&2
  exit 1
fi
