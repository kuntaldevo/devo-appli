
#  Validate there are directories available for the Customer and Cluster Parameters that are passed in.

#TODO:  Later we might validate the files inside of them as well AND even possibly generate them as well, if so Required


# Validate Customer Param
CUSTOMER_DIR="${PROJECT_ROOT}/infrastructure/cluster/${CUSTOMER_ID}/"

if [[ ! -e "$CUSTOMER_DIR" ]]; then
   echo "${ERROR}Directory '${CUSTOMER_ID}' does not exist in 'infrastructure/cluster/' ."
   exit 1;
fi

# Validate Cluster Param
CLUSTER_DIR="${PROJECT_ROOT}/infrastructure/cluster/${CUSTOMER_ID}/${CLUSTER_ID}"

if [[ ! -e "$CLUSTER_DIR" ]]; then
   echo "${ERROR}Directory '${CLUSTER_ID}' does not exist in 'infrastructure/cluster/${CUSTOMER_ID}/' ."
   exit 2;
fi
