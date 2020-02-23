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

#Add the meta annotation
kustomize edit add annotation --force approver-email:"$APPROVER_EMAIL"
kustomize edit add annotation --force cluster-id:"$CLUSTER_ID"
kustomize edit add annotation --force cluster-name:"$CLUSTER_NAME"
kustomize edit add annotation --force create-host:"$CREATE_HOST"
kustomize edit add annotation --force create-timestamp:"$CREATE_TIMESTAMP"
kustomize edit add annotation --force create-user:"$CREATE_USER"
kustomize edit add annotation --force distro-id:"$DISTRO_ID"
kustomize edit add annotation --force env-key:"$ENV_KEY"
kustomize edit add annotation --force expiration-date:"$EXPIRATION_DATE"
kustomize edit add annotation --force installation-id:"$INSTALLATION_ID"
kustomize edit add annotation --force region-id:"$REGION_ID"
kustomize edit add annotation --force scm-branch:"$SCM_BRANCH"
kustomize edit add annotation --force scm-email:"$SCM_EMAIL"
kustomize edit add annotation --force scm-sha:"$SCM_SHA"
kustomize edit add annotation --force scm-user:"$SCM_USER"

if [[ -n "$KUSTOMIZE_CONFIG" ]]; then
  kustomize edit add annotation --force kustomize-config:"$KUSTOMIZE_CONFIG"
fi
if [[ -n "$CURRENT_KUBERNETES_CONTEXT" ]]; then
  kustomize edit add annotation --force current-kubernetes-context:"$CURRENT_KUBERNETES_CONTEXT"
fi

if [[ -n "$ENV_KEY" ]]; then
  kustomize edit add configmap source-vars --from-literal CLUSTER-NAME="$ENV_KEY"
else
  kustomize edit add configmap source-vars --from-literal CLUSTER-NAME="$CLUSTER_NAME"
fi

kustomize edit add configmap source-vars --from-literal REGION-ID="$REGION_ID"

#Some configuration is account specific.  This makes it difficult to test a 'production' like configuration in the dev region.
kustomize edit add resource ../region/${ACCOUNT_ID}

# Because i add the `source-vars` then just automagically add the Vars. to the end of the ROOT Kustomization file

cat <<EOF >> kustomization.yaml
vars:
- name: CLUSTER-NAME
  objref:
    kind: ConfigMap
    name: source-vars
    apiVersion: v1
  fieldref:
    fieldpath: data.CLUSTER-NAME
- name: REGION-ID
  objref:
    kind: ConfigMap
    name: source-vars
    apiVersion: v1
  fieldref:
    fieldpath: data.REGION-ID
EOF

popd
