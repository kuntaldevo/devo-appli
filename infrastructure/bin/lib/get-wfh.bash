#!/usr/bin/env bash
# B A S H ! ! !

#If a WFH is available then get the user's IP
#This is used to update the Security settings for cloud Security
if [[ -n "$WFH" ]]; then

  which dig
  RETURN=$?

  if [[ -n "${RETURN}" ]]; then
    export IP_WFH="$(dig +short myip.opendns.com @resolver1.opendns.com)"
  else
    echo "Warning: WFH flag was set but unable to determine the Users's Public IP"
  fi



fi
