#!/usr/bin/env bash
# B A S H ! ! !

TARGET="$1"

pushd "${PROVIDER_ID}/${TARGET}"

rm -rf .terraform/ *.tfstate  terraform.tfstate.backup

popd
