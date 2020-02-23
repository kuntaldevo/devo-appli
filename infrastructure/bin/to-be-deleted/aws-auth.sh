#!/usr/bin/env bash
# B A S H ! ! !


# Validate that Init has been run

if [ -z "$PROJECT_ROOT" ]; then
    echo "Error:  Unable to find the Project Root.  Did you run init.sh first ?"
    exit 1
fi

# Initalize Constants etc
source "${PROJECT_ROOT}/tooling/bin/lib/constants.bash"

COMMAND="$1"

if [ -z "$COMMAND" ]; then
    echo "Required Command, either get or edit"
    exit 1
fi

case "$COMMAND" in
  get | view)
          kubectl describe configmap -n kube-system aws-auth
          ;;
  edit)
          kubectl edit  configmap -n kube-system aws-auth
          ;;
  *)
        echo "$ERROR Unknown Command"
        break
        ;;
esac
