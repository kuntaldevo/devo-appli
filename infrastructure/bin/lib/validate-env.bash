#!/usr/bin/env bash
# B A S H ! ! !

# Perform a Littany of Validations to prepare for managing Infrastructure

#  Additionally may ( will ) setup some variables that are optional

# Import the Version compare utility
source "${PROJECT_ROOT}/tooling/bin/lib/version-compare.bash"

###
# Validate required Env Vars exist
if [ -z "$REGION_ID" ]; then
    echo "Required Env Var REGION_ID is missing."
    exit 1
fi

# Validate suppoprting apps are installed

source "${INFRASTRUCTURE_BIN}/lib/validate-terraform.bash"

source "${INFRASTRUCTURE_BIN}/lib/validate-getopt.bash"

source "${INFRASTRUCTURE_BIN}/lib/validate-jq.bash"
