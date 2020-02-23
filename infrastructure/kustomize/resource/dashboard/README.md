
# Install Dashboard

`kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml`

# Create RBAC Token

  `kubectl apply -f kustomize/resource/dashboard`

# Bearer Token

Now we need to find token we can use to log in. Execute following command:

`kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')`

# Access Dashboard

Start the proxy `kubectl proxy`

#  Accessing the Dashboard

 http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
