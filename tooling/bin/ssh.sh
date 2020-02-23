#!/usr/bin/env bash
# B A S H ! ! !

if [ -z "$REGION_ID" ]; then
    echo "Required Env Var REGION_ID is missing."
    exit 1
fi

source "${PROJECT_ROOT}/tooling/get-local-values.bash"


KEY_FILE=""

case "$REGION_ID" in
        us-east-2)
            KEY_FILE="dev-keypair-east-2.pem"
            ;;
        *)
            echo $"Unknown Region of $REGION_ID"
            exit 1

esac

CLUSTER_URL=$(head -n 1 "${PROJECT_ROOT}/infrastructure/url.txt")

ssh -i "${PROJECT_ROOT}/tooling/ssh/${KEY_FILE}" ${CLUSTER_URL}
