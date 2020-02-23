# Getting Started

Installing the tools needed to leverage this project.

[Getting Started](installation/README.md)

# For Developer's personal / private work ....

Go to [for Developers](for-developers.md)

# For the SDLC to Production.....



## Kubernetes Addendum

[Kubernetes](kubernetes.md)

# Planning your New Cluster Deployment

Start here for information on how to begin setup of a new Customer and/or Cluster

[Configuration](application/README.md)

Information on standing up your cluster

[Infrastructure](infrastructure/README.md)

How to Create Virtual Machine Images

[Packaging](package/README.md)

# Troubleshooting

Also See:  [Known Issues & Limitations](known-issues.md)

## Provider Specific Help

[Help with AWS](aws.md)

# Accessing

The URL is set by the combination of the customer and the cluster names.

Paxata UI:  {customer}-{cluster}.paxatadev.com

Proxy: proxy.{customer}-{cluster}.paxatadev.com

The proxy allows SSH access into the cluster as well as access to the Spark UI on port 80 and the Jobs API on port 4040

# Project is broken down into key directories

## Application

Properties and 'facts' that are used to define and configure an customer's cluster.  Contains additional configuration specific on how to package VMIs

[See:](application/README.md)

## Infrastructure

Create your cluster's environment in the cloud

[See:](infrastructure/README.md)

## Local

Allows local creation and testing of servers locally

[See:](local/README.md)

## Package

Create Virtual Machine Images that are then grouped into Distributions.

[See:](package/README.md)

## Provider

Provider specific configuration variables. Primarily used by terraform to use. These settings are used across all provider specific infrastructure configurations.

[See:](provider/README.md)

## Provision

Used by 'Package' to setup the Virtual Machine Images

[See:](provision/README.md)

## Tooling

Additional libraries and scripts that are shared across both Packaging and Infrastructure to help monitor, configure and manage the project

[See:](tooling/README.md)

## Repository Branching Strategy
This repo will use a standard feature branching strategy:

![Branching Visualization](https://i.imgur.com/0YQL8Fo.png)

Master should always be stable, versioned, and fully functional.  New development should always occur in a branch.  Once that branch is ready to be merged to master, a Pull Request should be created and an Approver/Reviewer assigned to the PR;  only Gregory Bonk or Homer Najafi should approve a PR.  Either the person who created the PR or the Approver can merge to master after approval.

## Using Rebase

```
git fetch
git checkout master
git pull
git checkout <<branch_name>>
git pull
git rebase master
git push --force-with-lease
```


### TODO
1. Package devops-application into an usable artifact
   * e.g., docker container
1. Define and implement version number strategy
   * e.g., semantic versioning, tying to Paxata releases, etc.
1. Set up Continuous Build for Master and PR branches
1. Publish build artifacts to a Docker repository
