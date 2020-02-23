#!/usr/bin/env bash
# B A S H ! ! !


docker run --name paxinst \
  --mount type=bind,source="$(pwd)/..",target=/devops-application \
  --mount type=bind,source="$HOME/.gitconfig",target=/root/.gitconfig \
  --mount type=bind,source="$HOME/.ssh",target=/root/.ssh \
  --mount type=bind,source="$HOME/.aws",target=/root/.aws \
  --rm -i -t devops-application bash
