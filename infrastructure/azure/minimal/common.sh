#!/usr/bin/env bash
# B A S H ! ! !

export TF_VAR_PROJECT_ROOT="$(git rev-parse --show-toplevel)"

export TF_VAR_scm_branch="$(git rev-parse --abbrev-ref HEAD)"

export TF_VAR_scm_sha="$(git rev-parse ${TF_VAR_scm_branch} )"

export TF_VAR_scm_user="$(git config user.name)"

export TF_VAR_scm_email="$(git config user.email)"

export TF_VAR_CREATE_USER="$(echo $USER)"

export TF_VAR_CREATE_TIMESTAMP="$(date +%Y-%m-%dT%H:%M:%S%z)"

if false; then
  export TF_VAR_IP_WFH="$(dig +short myip.opendns.com @resolver1.opendns.com)"
fi
