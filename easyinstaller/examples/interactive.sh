#!/usr/bin/env bash
# B A S H ! ! !

export PROJECT_ROOT="$(git rev-parse --show-toplevel)"

docker-compose  -f interactive/docker-compose.yml run devops-application-interactive bash
