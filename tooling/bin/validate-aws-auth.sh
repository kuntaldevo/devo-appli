#!/usr/bin/env bash
# B A S H ! ! !

aws sts get-caller-identity  >/dev/null 2>&1
EXIT_CODE="$?"

if [[ "${EXIT_CODE}" != "0" ]]; then
  echo "${ERROR} You do not appear to be logged in.  Try running saml2aws first."
  exit "$EXIT_CODE"
fi
