#!/usr/bin/env bash
# B A S H ! ! !

# Must set this option, else script will not expand aliases.
shopt -s expand_aliases

#If we are explicitly echoing then we will probably have colors
alias echo="echo -e "

# Some constants

export AWS="aws"
export AZURE="azure"

export RED="\033[0;31m"
export YELLOW="\033[0;33m"
export GREEN="\033[0;32m"
export BLUE="\033[0;34m"

#With Bold
export BOLD_RED="\033[1;31m"
export BOLD_YELLOW="\033[1;33m"
export BOLD_GREEN="\033[1;32m"
export BOLD_BLUE="\033[1;34m"

export NC="\033[0m" # No Color

# Default Messages with Color
export ERROR="${BOLD_RED}Error:  ${NC}"
export WARNING="${BOLD_YELLOW}Warning:  ${NC}"
export WARN="${BOLD_YELLOW}Warning:  ${NC}"
export VALID="${BOLD_GREEN}Valid:  ${NC}"
export OK="${BOLD_GREEN}OK:  ${NC}"
export FYI="${BOLD_BLUE}FYI:  ${NC}"
