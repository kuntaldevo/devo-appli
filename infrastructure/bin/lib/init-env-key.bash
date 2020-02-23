#!/usr/bin/env bash
# B A S H ! ! !

#The ENV Key is needed by everyone and not just Terraform.
# Now that K8s and Kustomize is here, move this most important variable to a common area.

if [[ -z "$CUSTOMER_ID" && -z "$CLUSTER_ID"  ]]; then

  echo "${FYI} NO Customer or Cluster id to use for setting the env_key"

else

    # Create the ENV_KEY as late as possible
    if [[ -z "$STAGE_ID" ]]; then
      export ENV_KEY="${CUSTOMER_ID}-${CLUSTER_ID}"
    else
      export ENV_KEY="${CUSTOMER_ID}-${CLUSTER_ID}-${STAGE_ID}"
    fi

fi
