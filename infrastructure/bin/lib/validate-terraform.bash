#!/usr/bin/env bash
# B A S H ! ! !

# Validate that terraform is on the $PATH

WHICH_TERRAFORM=`command -v terraform`

# Check the terraform file exists
if ! [[ -f "${WHICH_TERRAFORM}" ]]; then
  echo '${ERROR}Terraform was not found in your $PATH.' >&2
  exit 1
fi

#Check to make sure terraform is executable
if ! [[ -x "${WHICH_TERRAFORM}" ]]; then
  echo '${ERROR}Terraform is not executable. ' >&2
  exit 1
fi

CURRENT_TERRAFORM=`terraform --version | sed -n "s/Terraform v\(.*\)/\1/p" `

#echo "${FYI}Terraform version: ${CURRENT_TERRAFORM} "


MIN_REQUIRED_TERRAFORM="0.11.14"

TERRAFORM_COMPARE=`version_compare ${CURRENT_TERRAFORM} ${MIN_REQUIRED_TERRAFORM}`

#echo "${FYI}Terraform Compare: ${TERRAFORM_COMPARE} "


if [[ "${TERRAFORM_COMPARE}" -lt "0" ]]; then
  echo "${ERROR}Terraform must be at minimum version ${MIN_REQUIRED_TERRAFORM}.  Your version ${CURRENT_TERRAFORM} " >&2
  exit 1
fi

NOT_GREATER_THAN_REQUIRED_TERRAFORM="0.13.0"

#TERRAFORM_COMPARE=`version_compare ${CURRENT_TERRAFORM} ${NOT_GREATER_THAN_REQUIRED_TERRAFORM}`

#if [[ ! "${TERRAFORM_COMPARE}" -lt "0" ]]; then
#  echo "${ERROR}Terraform version ${NOT_GREATER_THAN_REQUIRED_TERRAFORM} is not supported. " >&2
#
#  echo "For MacOS try:  'brew install terraform@0.11'  then 'brew unlink terraform'  then  'brew link terraform@0.11 --force' "
#
#  exit 1
#fi
