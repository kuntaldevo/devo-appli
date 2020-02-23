# Overprovisioning

Overprovisioning means intentionally provisioning more hardware than we need. We do this specifically for the Nodes used by our pipeline Pods in order to minimize the time it takes to start a pipeline. Our aproach is taken from the Kubernetes [cluster autoscaler documentation](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#how-can-i-configure-overprovisioning-with-cluster-autoscaler).

We also have cron jobs defined here so that we can set different numbers of overprovisioned Nodes for day and night. The idea is that we can probably go down to 0 at night and over the weekends. The values are set as env vars on the containers, so it's easy to override them with kustomize.
