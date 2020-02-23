#!/usr/bin/env bash
# B A S H ! ! !

UNAME="$(uname -a)"

if [[ "${UNAME}" = *Darwin* ]]; then
  export IS_MAC="true"
fi

if [[ "${UNAME}" = *MINGW32_NT* ]]; then
  export IS_PC="true"
fi
