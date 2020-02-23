

# Velero via Kustomize

### Manual add to EKS cluster


#### YAML to standard out
` ./bin/kustom-resource.sh velero`

#### YAML Apply
` ./bin/kustom-resource.sh velero apply`





# Velero Initial Setup Notes

# Github repo and releases

* https://github.com/vmware-tanzu/velero/releases

* Plugin for AWS:  https://github.com/vmware-tanzu/velero-plugin-for-aws


# Install Velero on MacOS

Velero interacts with a local client and access to the remote repo.

Use Brew `brew install velero`

# Creating YAMLs

Create a credentials file.  This will be blocked by gitignore from being checked in.

To get the correct credentials check in Last Pass and create a file in the build directory named `cloud`

Verify the AWS Plugin is the most recent

Run velero locally in this directory with the following command....

```
cd kustomize/resource/velero

velero install --dry-run --bucket \$\(BACKUP-BUCKET-NAME\) --backup-location-config region=\$\(REGION-ID\)  --provider aws --secret-file cloud --prefix \$\(CLUSTER-NAME\) --use-restic --output yaml --plugins velero/velero-plugin-for-aws:v1.0.0 > velero-install.yaml
```
And copy the complete output into `infrastructure/kustomize/resource/velero/velero-install.yaml`

NOTE: The bucket name and the cluster name are kustomize replacement variables.

# Interacting with Velero

Install Velero via Brew for MacOS

Be authenticated as an admin or velero role
