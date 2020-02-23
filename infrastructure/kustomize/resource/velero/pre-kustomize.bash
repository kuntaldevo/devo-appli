#!/usr/bin/env bash
# B A S H ! ! !

error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}
trap 'error ${LINENO}' ERR


pushd "${WORK_DIR}"


### Add a Backup BUcket name based on the cluster name
kustomize edit add configmap source-vars --from-literal BACKUP-BUCKET-NAME="${ENV_KEY}.velero.backup.devops.paxata.com"


# Because i add the `source-vars` then just automagically add the Vars. to the end of the ROOT Kustomization file

cat <<EOF >> kustomization.yaml
- name: BACKUP-BUCKET-NAME
  objref:
    kind: ConfigMap
    name: source-vars
    apiVersion: v1
  fieldref:
    fieldpath: data.BACKUP-BUCKET-NAME
EOF

popd
