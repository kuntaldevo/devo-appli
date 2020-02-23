


# Get Customer's Cluster Shell configuration, This defines where everything else is found
if [[ -n "$DEVELOPER" ]]; then
  CUSTOMER_CLUSTER="${PROJECT_ROOT}/infrastructure/cluster/paxata/${CLUSTER_ID}/cluster.config"
else
  CUSTOMER_CLUSTER="${PROJECT_ROOT}/infrastructure/cluster/${CUSTOMER_ID}/${CLUSTER_ID}/cluster.config"
fi

if [[ -f "$CUSTOMER_CLUSTER" ]]; then
   source "${CUSTOMER_CLUSTER}"
else
   echo "${ERROR}Customer Cluster: $CUSTOMER_CLUSTER does not exist.${NC}"
   exit 4
fi
