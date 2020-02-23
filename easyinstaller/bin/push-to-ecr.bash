#!/bin/bash
set -ex

#TODO MAKE THIS LINUX COMPLIANT
BUILD_NUMBER=$(date +%Y%m%dT%H%M%S%z)

IMAGE_NAME="$1"


docker tag "$IMAGE_NAME:local" "$ECR_URL/$IMAGE_NAME:$BUILD_NUMBER"
docker tag "$IMAGE_NAME:local" "$ECR_URL/$IMAGE_NAME:latest"

docker push "$ECR_URL/$IMAGE_NAME:$BUILD_NUMBER"
docker push "$ECR_URL/$IMAGE_NAME:latest"
