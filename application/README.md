# Architecture

The files and settings in this area is where you will define the properties of the environment you want to use.




# Application Configuration

This area contains most if not all of the configuration options for building infrastructure and creating VMIs

Three main areas

## Customer

* Controls the settings for a grouping of machines

This folder is further broken down by a named customer folder then a customer's cluster folder.  These two folder names are used to form the ENV-KEY

The ENV-KEY is the primary means that identifies an infrastructure.  The ENV-KEY is agnostic to the region and provider.  The idea being that and ENV-KEY grouping can be installed exactly the same regardless of the Cloud Provider or the region.

See the Customer folder [read-me for more details](customer/README.md)...

## Distro

* Controls VMI Id's to use.

The Distro is set in a Customer's, Cluster's, cluster.config file.

Contains version specific configurations for either packaging a specific version ( Distro) of paxata or the information on region specific VMIs when deploying a Customers's cluser with the specified Distro.

See the Distro folder [read-me for more details](distro/README.md)...

## I-Size

* Controls Instance Type, and Volume Properties.

The iSize is set in a Customer's, Cluster's, cluster.config file.

The specific sizing of the infrastructure. A customer's cluster is defines the isize to use in the `cluster.config`.  The matching infrastructure properties describes to terraform the server sizing ( instance type, volume size etc ) to use when initializing a cluster.

See the I-Size folder [read-me for more details](isize/README.md)...

## Deploying Customer's Application

If you have the cluster you want already in your kubectl context then you can just,

`./init.sh --customer <Name of the Customer>`

otherwise then add the region and the cluster to use a specific region and cluster

./init.sh --customer <Name of the Customer> --cluster <EKS cluster Name> --region <AWS Region>

### Debugging a Customer's Application

Once initialized (i.e., `./init.sh --customer --cluster --region`), simply run `debug.sh` to have a zipped dump of logs, events, and resources for the initialized Namespace, output to `<devops-app>/application/logs/`

# Creating a Customer's configuration.

TODO:  FOR NOW, just copy another's as an example.

The location of application/customer/<<customer-name>>/kustomize can be customized to your needs.

# Cluster management

the script `kustom-app.sh` is used to create or update customer contexts.

### Options

* No Option: the kustomized yaml will be displayed on the screen via standard out.
* write:  the kustomized yaml is written to application/customer/<<customer-name>>/kubernetes
* apply: first the kustomized yaml is written as above and then applied
* delete:  The yaml in application/customer/<<customer-name>>/kubernetes is used to delete the cluster.
