#!/usr/bin/env bash

#Define the backend storage for Azure

# Name of the Azure Storage Account
bucket_name="tfstate0${CUSTOMER_ID}0${CLUSTER_ID}0"

# The path to your TF state in the bucket.
bucket_key="terraform-state/core-terraform.tfstate"

# The region your bucket is located in.
bucket_region="${REGION_ID}"

# The path of the config file. This should be excluded in your source
# control!
remote_config_file="remote_config_file.tf"

# Write out a TF config that contains all of the pertinent data in it.
#
# WARNING: Do not include credentials in this file! If you need credentials
# (ie: AWS creds when not using environment or instance profiles), supply
# them directly via "terraform init -backend-config= 'key=value'" command
# switches. This can be added to the init command below.
cat > "${remote_config_file}" <<EOS
# Automatically generated file - DO NOT EDIT!
# Ensure that this file is excluded from our source control!
terraform {
  backend "azurerm" {
    storage_account_name = "${bucket_name}"
    container_name  = "${bucket_key}"
    key     = "${bucket_region}"

    resource_group_name = "tfstate.${ENV_KEY}"
    arm_subscription_id = "${AZURE_SUBSCRIPTION_ID}"
    arm_client_id  = "${AZURE_CLIENT_ID}"
    arm_client_secret = "${AZURE_CLIENT_SECRET}"
    arm_tenant_id = "${AZURE_TENANT_ID}"
  }
}
EOS

echo "Generated ${remote_config_file}"

# OPTIONAL. Wipe the .terraform and terraform.tfstate artifacts to
# make sure that you are not prompted for migration, which may
# break runs when running non-interactively. Note - this may
# possibly blow away data - back up accordingly! Obviously remove
# this if you WANT state to be migrated/copied.
rm -rf .terraform/ *.tfstate  terraform.tfstate.backup

echo "Cleaned Prior State files"

# Run "terraform init" to write out the .terraform/terraform.tfstate
# file. This file is a stub and will not contain any state data.
# Remove -input=false if you need prompts on state migration/copy.
terraform init -input=false

echo "Initialized Terraform"
