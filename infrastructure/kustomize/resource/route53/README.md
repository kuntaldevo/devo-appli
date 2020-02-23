
# Route 53 DNS management

https://github.com/kubernetes-incubator/external-dns/releases

Using the manifest for clusters with RBAC

https://github.com/kubernetes-incubator/external-dns/blob/master/docs/tutorials/aws.md

Updated the areas recommended with replacement variables for Kustomize

# Manually Made Changes

## Make version explicit

image: registry.opensource.zalan.do/teapot/external-dns:latest

TO

image: registry.opensource.zalan.do/teapot/external-dns:v0.5.16

## Update the domain filter the domain we are updating

- --domain-filter=external-dns-test.my-org.com # Makes ExternalDNS see only the namespaces that match the specified domain. Omit the filter if you want to process all available namespaces.

TO

- --domain-filter=$(DOMAIN-FILTER)

## Disabled upsert

- --policy=upsert-only # would prevent ExternalDNS from deleting any records, omit to enable full synchronization


## Set the Zone Type

Public for Prod and private for dev

- --aws-zone-type=public # only look at public hosted zones (valid values are public, private or no value for both)

TO

- --aws-zone-type=$(AWS-ZONE-TYPE)

## Owner Identifier

- --txt-owner-id=my-hostedzone-identifier

TO

- --txt-owner-id=eks-cluster-$(CLUSTER-NAME)

## Enabled Debug

- --log-level=debug
