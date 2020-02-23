
# Apply kustomize

## Dev

kustomize build kustomize/overlays/dev | kubectl apply -f -

## Prod

kustomize build kustomize/prod | kubectl apply -f -

# Diff

Note:  Need K8s 1.13

kustomize build kustomize/prod | kubectl diff -f -


#Trying to use Environment Variables to create / update a ConfigMap

  touch kustomization.yaml
  kustomize edit fix
  kustomize edit add configmap pax-operator-env --from-literal USER_HOME="$HOME"
  kustomize edit set namespace staging


## Result

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
configMapGenerator:
- literals:
  - USER_HOME=/Users/gregory
  name: pax-operator-env
namespace: staging
```

## Build Output

```
apiVersion: v1
data:
  USER_HOME: /Users/gregory
kind: ConfigMap
metadata:
  name: pax-operator-env-8d98d25656
  namespace: staging
```
