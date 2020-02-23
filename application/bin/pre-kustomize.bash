#!/usr/bin/env bash
# B A S H ! ! !

pushd "${WORK_DIR}"

#Add the meta annotation
kustomize edit add annotation --force approver-email:"$APPROVER_EMAIL"
kustomize edit add annotation --force cluster-id:"$CLUSTER_ID"
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

kustomize edit set namespace "$CUSTOMER_ID"

export CLUSTER_NAME=`basename $(kubectl config current-context)`

kustomize edit add configmap customer-configmap --from-literal CLUSTER-NAME="$CLUSTER_NAME"
kustomize edit add configmap customer-configmap --from-literal CUSTOMER-NAME="$CUSTOMER_ID"

#TODO this is likely wrong
#kustomize edit add configmap customer-configmap --from-literal INSTALLATION-NAME=eks

### Though I have used set namespace to put everything in a namespace,
#  it appears that I can not actually create the namespace resource dynamically
# as VARS does not allow updating of the metadata.name
#  https://github.com/kubernetes-sigs/kustomize/issues/1475

cat << EOF > "$WORK_DIR/namespace.yaml"
apiVersion: v1
kind: Namespace
metadata:
  name: $CUSTOMER_ID
  labels:
    paxata.com/is-customer: "true"
EOF


kustomize edit add resource namespace.yaml


popd
