#!/usr/bin/env bash
# B A S H ! ! !

WHICH=`command -v jq`

# Check the terraform file exists
if ! [[ -f "${WHICH}" ]]; then
  echo '${ERROR}JQ was not found in your $PATH.' >&2
  echo '${FYI}Install JQ, brew install jq' >&2
  exit 1
fi
