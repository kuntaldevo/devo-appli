#!/usr/bin/env bash
set -e
die() {
        if [ -z "$PS1" ];then
                echo "$1" >&2
        fi
        if [ $# -eq 2 ];then
                exit "$2"
        fi
        exit 1
}

[[ $# -ge 1 ]] || die "Usage: ${0} <namespace> [port to forward, or 4040]"
NAMESPACE=${1}
SERVICE_PORT=${2:-4040}
SELECTOR="app.kubernetes.io/name=pipeline,spark-role=driver"
KUBE_OPTS="-n ${NAMESPACE} --selector ${SELECTOR} -o name --no-headers"

kubectl get pods ${KUBE_OPTS} | while read name;do
  kubectl port-forward -n ${NAMESPACE}  ${name} ${SERVICE_PORT} --pod-running-timeout=10s

  offset=$(( offset + 1 ))
done
