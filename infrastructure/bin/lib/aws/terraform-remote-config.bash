#!/usr/bin/env bash

# https://gist.github.com/vancluever/d9c4235b1d754f7c8c9517987c1fea5b
# Say you have a S3 state with KMS on, with the appropriate variables
# configured below (these could also be parameterized but I wanted to
# make this gist as easy as possible to digest). Using this script
# (or a reasonable facsimile thereof), you can emulate the old
# "terraform remote config" command that existed in TF pre-v0.9
# by creating a file with your config in your Terraform directory.
# This file should be ignored in source control!

# Default the TF State Bucket location to the current Provider REGION_ID
# The region your bucket is located in.
bucket_region="${REGION_ID}"

if [[ -n "$DEVELOPER" ]]; then

  # Always use the bucket in us-west-2
  bucket_region="us-west-2"

fi




# Your s3 bucket.
# Developers use a shared bucket
if [[ -n "$DEVELOPER" ]]; then
  bucket_name="tfstate.paxata-developer.devops.paxata.com"
else
  bucket_name="tfstate.${CUSTOMER_ID}-${CLUSTER_ID}.${bucket_region}.devops.paxata.com"
fi


# Developers use a shared bucket, so their individual state is stored different location
if [[ -n "$DEVELOPER" ]]; then

  if [[ -z "$TF_DIR" ]]; then
    bucket_key="${CUSTOMER_ID}/${CLUSTER_ID}.tfstate"
  else
    bucket_key="${CUSTOMER_ID}/${CLUSTER_ID}.${TF_DIR}.tfstate"
  fi

else

  #The target variable is set in the remote up/down scripts if the end user specified a 'target'
  # The path to the TF state in the bucket.
  if [[ -z "$TF_DIR" ]]; then
    bucket_key="${ENV_KEY}.tfstate"
  else
    bucket_key="${ENV_KEY}.${TF_DIR}.tfstate"
  fi

fi

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
# File generated by infrastructure/bin/lib/aws/terraform-remote-config.bash
terraform {
  backend "s3" {
    bucket     = "${bucket_name}"
    key        = "${bucket_key}"
    region     = "${bucket_region}"
  }
}
EOS

echo "Generated ${remote_config_file}"

# OPTIONAL. Wipe the .terraform and terraform.tfstate artifacts to
# make sure that you are not prompted for migration, which may
# break runs when running non-interactively. Note - this may
# possibly blow away data - back up accordingly! Obviously remove
# this if you WANT state to be migrated/copied.
rm -rf .terraform/*.tfstate .terraform/modules *.tfstate  terraform.tfstate.backup

echo "Cleaned Prior State files"

# Run "terraform init" to write out the .terraform/terraform.tfstate
# file. This file is a stub and will not contain any state data.
# Remove -input=false if you need prompts on state migration/copy.
terraform init -input=false

echo "Initialized Terraform"
