#!/bin/bash

# Script to start Infrastructure install.

# This expects all of the required environment variables to have been passed in to the docker run command

git clone git@github.com:Paxata/devops-application.git

cd devops-application/infrastructure

git checkout "OPS-660"

#git config user.email $CUSTOMER_ID@github.com

# Set and environment variable that allows other scripts to know the main relative context
# Only relative path we will code for.  Once we have the project_root we can use full paths
source "../tooling/project-root.sh"
export PROJECT_ROOT

source "${PROJECT_ROOT}/infrastructure/bin/remote.bash"  "$ACTION"
