#!/usr/bin/env bash
# B A S H ! ! !

source ./bin/ecr-properties.bash

REPO_NAME="devops-application/base-tooling"

LOCAL_IMAGE_NAME="$REPO_NAME:local"

docker build -t "$LOCAL_IMAGE_NAME" base-tooling/

source ./bin/check-ecr-repo.bash "$REPO_NAME"

source ./bin/push-to-ecr.bash "$REPO_NAME"
