#!/usr/bin/env bash
# B A S H ! ! !

# Use the Base and add a means when the container starts it will checkout from Git and run a command.
# This just sets up the means to do so when the container starts.

source ./bin/ecr-properties.bash

REPO_NAME="devops-application/developer-eks"

LOCAL_IMAGE_NAME="$REPO_NAME:local"

source ./bin/pull-from-ecr.bash "devops-application/base-tooling:latest"

docker build -t "$LOCAL_IMAGE_NAME" developer-eks/

source ./bin/check-ecr-repo.bash "$REPO_NAME"

source ./bin/push-to-ecr.bash "$REPO_NAME"
