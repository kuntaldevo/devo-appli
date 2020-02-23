#!/bin/bash
set -ex

docker pull "$ECR_URL/$1"

docker tag "$ECR_URL/$1" "$1"
