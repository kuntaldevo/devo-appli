#!/usr/bin/env bash
# B A S H ! ! !

#NOTE all paths are from the infrastructure dir


UP_DOWN="$1"
# Check the Provider/Target to see if they have a post configuration to run
# if [[ -f "pre-terraform/up.bash"]]
#
# run the pre configuration
# return the Exit Code to see if we want to continue with Terraform
