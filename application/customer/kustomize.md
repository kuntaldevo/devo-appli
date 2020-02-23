Creating your application via Kustomize

# Init your shell

`./init.sh --customer perf --cluster paxata-perf-dev --region us-west-2`

1. The CUSTOMER folder name
2. The full name of the EKS Cluster deploying to
3. The region the cluster is in


# Usage of kustom-app.sh script
This script is used to deploy any new customer based on the t-shirt size chosen.

usage: ./kustom-app.sh [options] [apply | write | <blank>]
Options:
-h: print help message and exit
-s <pax-size>: use the given to configure specific pax sizes (e.g. pax-1,pax-2,pax-5,pax-10 etc.).

## How to provide T-shirt size for an installation
`-s` option is pro providing the T-shirt size.

example:
./kustom-app.sh -s pax-50

## Options while creating the pax-installation yaml
Users will have options either to create the installation at a go or just the yaml file (in a file or terminal).
The 2nd option is to have review before applying the yaml.

example:

./kustom-app.sh -s pax-50 apply --- will create the pax installation of size pax-50 for the customer

./kustom-app.sh -s pax-50 write --- will create the pax installation yaml file of size pax-50 for the customer, however will not apply

./kustom-app.sh -s pax-50 write --- will show the pax installation yaml file of size pax-50 for the customer on the terminal, however will not apply
