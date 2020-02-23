#!/bin/bash
set -ex

eval $(aws ecr get-login --no-include-email --region us-west-2 )

#NOTE: Do not add port
ecr_repo="011447054295.dkr.ecr.us-west-2.amazonaws.com"

docker tag devops-application:latest $ecr_repo/devops-application:latest

docker push $ecr_repo/devops-application:latest
