#!/usr/bin/env bash
# B A S H ! ! !

#  This file should be agnostic to the actual tool that is provisioning the infrastructure


# Get the Platform
source ${PROJECT_ROOT}/tooling/bin/lib/get-platform.bash

#Make sure we are in the project root directory to perform Git calls

pushd "${PROJECT_ROOT}"

### To view your current git config,  git config --list
## Note: there are also --global (in ~) --system & --local ( repo )
# System on MacOS can be in the following
## /usr/local/etc/gitconfig


export SCM_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

export SCM_SHA="$(git rev-parse ${SCM_BRANCH} )"

# if Missing, git config --global --add user.name
export SCM_USER="$(git config user.name)"

if [[ -z "$SCM_USER" ]]; then
  echo "Git Config 'user.name' is required. Do..."
  echo ">  git config --global --add user.name <<username>>"
  exit 12
fi

export SCM_EMAIL="$(git config user.email)"

if [[ -z "$SCM_EMAIL" ]]; then
  echo "Git Config 'user.email' is required. Do..."
  echo ">  git config --global --add user.email <<email@somewhere.com>>"
  exit 13
fi

if [[ "$SCM_EMAIL" == *root* ]]; then
  echo "A valid, personal email is required. Do..."
  echo ">  git config --global --add user.email <<email@somewhere.com>>"
  exit 14
fi

popd

export CREATE_USER="$(echo $USER)"

export CREATE_HOST="$(hostname)"

if [[ -n "$IS_MAC" ]]; then
  export CREATE_TIMESTAMP="$(date +%Y-%m-%dT%H:%M:%S%z)"
else
  export CREATE_TIMESTAMP="$(date +%Y-%m-%dT%H:%M:%S%z)"
fi

#Default the expiration for 7 Days.  Since this is in development I won't remember what something is for after 7 days
if [[ -n "${IS_MAC}" ]]; then
  export EXPIRATION_DATE="$(date -v+7d +%Y-%m-%d)"
else
  export EXPIRATION_DATE="$(date -d '+7 days' '+%Y-%m-%d' )"
fi

source "${PROJECT_ROOT}/tooling/bin/lib/get-aws-account-id.bash"
