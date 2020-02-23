#!/usr/bin/env bash
# B A S H ! ! !

#Define Defaults

#KUSTOMIZE yaml that has been checked into source control
if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

export WORK_DIR="${PROJECT_ROOT}/application/.workdir"
mkdir -p $WORK_DIR

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

#Start Time
start_time=`date +%s`

echo "${FYI} Start Time: `date`"

source "${INFRASTRUCTURE_BIN}/lib/init-env-key.bash"

# Get GIT and Shell ENV vars. This is warming up to create the tag-map
source "${PROJECT_ROOT}/tooling/bin/lib/get-local-vars.bash"

# Command line UI
function bail() {
    cat << EOF
usage: $0 [options] [apply | write | <blank>]
Options:
-h: print help message and exit
-s <pax-size>: use the given to configure specific pax sizes (e.g. pax-1,pax-2,pax-5,pax-10 etc.).
EOF
echo $1
exit 1
}

POSITIONAL_ARGS=""
while [ $# -gt 0 ]; do
    while getopts "hs:" arg; do
        case "$arg" in
            h)
                bail
                ;;
            s)
                PAX_SIZE="$OPTARG"
                ;;
        esac
    done
    shift $((OPTIND-1))
    POSITIONAL_ARGS="${POSITIONAL_ARGS}$1"
    shift || true
done

KUBECTL_WHAT=${POSITIONAL_ARGS}

### The Validate there is a T-shirt size is set
if [[ -z "$PAX_SIZE" ]]; then
  ## The current t-shirt size for this customer to be extracted from the application.yaml & will ne used for futher processing
  PAX_SIZE=`cat ${PROJECT_ROOT}/application/customer/${CUSTOMER_ID}/kubernetes/application.yaml | grep T-SHIRT | awk -F"=" {'print $2'}`
  if [[ -z "$PAX_SIZE" ]]; then
    echo "T-shirt size for this pax installation hasn't been provided. Setting it to default 'pax-2'"
    export PAX_SIZE="pax-2"
  fi
fi

### The Validate if there is a Region set
if [[ -z "$REGION_ID" ]]; then
  # The region ID can be set as default as well, us-west-2 for dev & us-east-1 for prod, however the user will have options to pass it as an argument
  [ ${ACCOUNT_ID} == "011447054295" ] && REGION_ID="us-west-2" || REGION_ID="us-east-1"
fi

if [[ -n "$CLUSTER_ID" ]]; then
  # Check if the cluster exists in the region mentioned. If it doesn;t exits the script should stop proceeding further
  TEMP_CLUSTER_ID=`aws eks list-clusters --region ${REGION_ID} | grep ${CLUSTER_ID} | awk -F'"' {'print $2'}`
  if [[ ${TEMP_CLUSTER_ID} != ${CLUSTER_ID} ]];then
    echo "The Cluster with ID '${CLUSTER_ID}' doesn't exists in the region '${REGION_ID}'!!!"
    echo ""
    exit 2
  fi
fi

# Validate Customer Directory Exists
CUSTOMER_DIR="${PROJECT_ROOT}/application/customer/${CUSTOMER_ID}/"
KUSTOMIZE_DIR="${PROJECT_ROOT}/application/customer/${CUSTOMER_ID}/kustomize/"

### Validate the Customer Directory
if [[ ! -e "${CUSTOMER_DIR}" ]]; then
   echo "Directory '${CUSTOMER_ID}' does not exist in 'application/customer/'."
   echo "Creating the directory for the customer ${CUSTOMER_ID}"
   mkdir -p ${CUSTOMER_DIR}
fi

### if the kustomization directory doesn't exist for the customer, that mean the customer need to be onborded & its a new customer
if [[ ! -e "${KUSTOMIZE_DIR}" ]]; then

   echo "Directory '${KUSTOMIZE_DIR}' does not exist in '${CUSTOMER_DIR}'."
   echo "Creating it for the customer ${CUSTOMER_ID}"
   mkdir -p ${KUSTOMIZE_DIR}
   sed s/PAX_SIZE/${PAX_SIZE}/g ${PROJECT_ROOT}/application/kustomize/kustomization.yaml > ${KUSTOMIZE_DIR}/kustomization.yaml
   cp ${PROJECT_ROOT}/application/kustomize/varconfig.yaml ${KUSTOMIZE_DIR}
#TODO:  We need to be smarter than this and not just wholesale overwrite a customer's existing kustomization.
#else ### the kustomization directory exits, that mean the customer has already been onborded & its an existing customer
#
#   echo "The ${CUSTOMER_ID} has already been onborded, so its a update scenario."
#
#   ### Check if it a size change
#   grep ${PAX_SIZE} ${KUSTOMIZE_DIR}/kustomization.yaml
#   if [[ $? -ne 0 ]]; then
#      echo "The customer ${CUSTOMER_ID} is migrating to a new pax configuration of size ${PAX_SIZE}"
#      sed s/PAX_SIZE/${PAX_SIZE}/g ${PROJECT_ROOT}/application/kustomize/kustomization.yaml > ${KUSTOMIZE_DIR}/kustomization.yaml
#   fi
#
fi

#Set the shell with the values passed in
export PAX_SIZE

# The KUSTOMIZE_DIR directory will be rsynced into the workdir
rm -rf "${WORK_DIR}/*.*"
cp -a ${KUSTOMIZE_DIR}/*.* "${WORK_DIR}/"

# Make the destination Dir available fort pre as there is some yaml generated too
export DESTINATION_DIR="${PROJECT_ROOT}/application/customer/${CUSTOMER_ID}/kubernetes"
mkdir -p "$DESTINATION_DIR"

source "${PROJECT_ROOT}/application/bin/pre-kustomize.bash"

CREATION_DATE=$(date +%Y-%m-%dT%H:%M:%S%z)
DONT_EDIT=$(cat <<EOF
###
### DO NOT EDIT.  FILE GENERATED BY KUSTOMIZE WITH T-SHIRT SIZE=${PAX_SIZE}
### ${CREATION_DATE}
EOF
)

###  Add some alaises because I get confused at times.
if [[ "$KUBECTL_WHAT" == "up" ]]; then
  KUBECTL_WHAT="apply"
elif  [[ "$KUBECTL_WHAT" == "down" ]]; then
  KUBECTL_WHAT="delete"
fi


# if apply was actually specified then write the YAML to disk and apply it
if [[ "$KUBECTL_WHAT" == "write" ]]; then

  kustomize build --load_restrictor none "${WORK_DIR}/"  | (echo "$DONT_EDIT" && cat) > "$DESTINATION_DIR/application.yaml"

elif [[ -n "$KUBECTL_WHAT" ]]; then

  kustomize build --load_restrictor none "${WORK_DIR}/"  | (echo "$DONT_EDIT" && cat) > "$DESTINATION_DIR/application.yaml"

  kubectl "$KUBECTL_WHAT" -f "$DESTINATION_DIR/application.yaml"

else # just output to STD out
  kustomize build --load_restrictor none "${WORK_DIR}/"
fi

end_time=`date +%s`

deltatime=$(( end_time - start_time ))
minutes=$(( deltatime / 60 ))
seconds=$(( deltatime % 60 ))

echo "$FYI End Time: `date`"
printf "$FYI Time spent: %02d:%02d\n" $minutes $seconds

if [[ "${EXIT_CODE}" > "0" ]]; then

  echo "\n${ERROR} Kubectl returned exit code ${EXIT_CODE}. Error messages should have been provided.\n"

  exit $EXIT_CODE
fi