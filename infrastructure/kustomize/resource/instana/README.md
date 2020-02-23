
# Instana agents

https://docs.instana.io/quick_start/agent_setup/container/kubernetes/#agent-installation-through-yaml-file

Scrolling down you can find this link to download the latest yaml

# Manual Changes

Updated the instana zone to use the Cluster-Name interpolation

```
- name: INSTANA_ZONE
  value: k8s-cluster-name
```

TO

```
- name: INSTANA_ZONE
  value: $(CLUSTER-NAME)
```
