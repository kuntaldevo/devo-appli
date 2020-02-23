#!/usr/bin/env bash
# B A S H ! ! !

UP_DOWN="$1"
TF_OK="$2"


if [[ $TF_OK >  0 ]]; then
  echo "$FYI Post Terraform Hook received a terraform error.  Nothing to do."
  return $TF_OK
fi


# Check the Provider/Target to see if they have a post configuration to run
# Future might have a hook that is based on Region or account
# run the post configuration
# return the Exit Code ( at the moment can't think why we would need it though )

POST_HOOK_LOC="${PROJECT_ROOT}/infrastructure/${PROVIDER_ID}/${INFRASTRUCTURE_ID}/post-terraform-$UP_DOWN.bash"

if [[ -f "$POST_HOOK_LOC" ]]; then
  source "$POST_HOOK_LOC"
fi
