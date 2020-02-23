#!/bin/bash

# Script to start Infrastructure install.
BRANCH_NAME="$1"
ACTION="$2"

# This expects all of the required environment variables to have been passed in to the docker run command
cd /root

git clone --single-branch --branch "$BRANCH_NAME"  git@github.com:Paxata/devops-application.git

cd /root/devops-application/infrastructure

source "../tooling/project-root.sh"
export PROJECT_ROOT

#git config user.email $CUSTOMER_ID@github.com

source "./bin/remote.bash"  "$ACTION"
