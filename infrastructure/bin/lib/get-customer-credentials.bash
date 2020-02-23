

if [[ -n "$DEVELOPER" ]]; then
  CUST_PROVIDER_CREDS="${PROJECT_ROOT}/application/customer/paxata/${PROVIDER_ID}.credentials"
else
  CUST_PROVIDER_CREDS="${PROJECT_ROOT}/application/customer/${CUSTOMER_ID}/${PROVIDER_ID}.credentials"
fi

if [[ -f "$CUST_PROVIDER_CREDS" ]]; then
   source "${CUST_PROVIDER_CREDS}"
else
   echo "${WARN}Customer Provider: $CUST_PROVIDER_CREDS does not exist.${NC}"
   echo "${FYI}setting to use default provider"
   export profile_id="default"
fi
