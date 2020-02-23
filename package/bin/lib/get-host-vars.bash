#!/usr/bin/env bash
# B A S H ! ! !

###
# Validate required Env Vars exist
if [ -z "$PROJECT_ROOT" ]; then
    echo "Required Env Var PROJECT_ROOT is missing."
    exit 1
fi


###
# Validate required Env Vars exist
if [ -z "$DISTRO_ID" ]; then
    echo "Required Env Var DISTRO_ID is missing."
    exit 1
fi

export GROUP_VAR_PATH="${PROJECT_ROOT}/application/distro/${DISTRO_ID}/provision/groups"
export HOST_VAR_PATH="${PROJECT_ROOT}/application/distro/${DISTRO_ID}/provision/hosts"
