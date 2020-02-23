
# NGINX Ingress Controller

This works together in conjunction with the external-dns pod ( ie. Route53 )

https://kubernetes.github.io/ingress-nginx/deploy/#aws

https://github.com/kubernetes/ingress-nginx

NOTE:  Because we have completely re-configured the Layer-7 configmap, We don't use the config map that is provided by ingress-nginx.  Because with Kustomize we can not patch a patch

Source YAML Using Layer 7

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/aws/service-l7.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/aws/patch-configmap-l7.yaml
