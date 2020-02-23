
if [[ -z "$TF_DIR" ]]; then
  # Change to the correct directory for Terraform.  The INFRASTRUCTURE_ID was defined in a Customer/Cluster file
  pushd "${PROJECT_ROOT}/infrastructure/${PROVIDER_ID}/${INFRASTRUCTURE_ID}"
else
# Use the overlay override
  pushd "${PROJECT_ROOT}/infrastructure/${PROVIDER_ID}/${TF_DIR}"
fi

#Generate the Backend.tf
source "${INFRASTRUCTURE_BIN}/lib/${PROVIDER_ID}/terraform-remote-config.bash"

#Run Terraform
if [[ -z "$TF" ]]; then
  eval "${DEBUG} terraform apply ${AUTO_APPROVE} ${TF_PARAMS}"
else
  eval "${DEBUG} terraform ${TF}"
fi

EXIT_CODE=$?

popd

return $EXIT_CODE
