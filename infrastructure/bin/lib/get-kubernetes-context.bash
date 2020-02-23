
export CURRENT_KUBERNETES_CONTEXT="$(basename $(kubectl config current-context))"

#The Context is usually an EKS AWS ARN
export CURRENT_KUBERNETES_REGION="$(kubectl config current-context | awk -F':' '{ print $4 } ' )"
