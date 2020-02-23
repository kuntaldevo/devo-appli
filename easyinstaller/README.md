# Easy Installer

Using Docker, we can eliminate most pre-requistes and configuration but not quite all.  When you use a Docker created container for development etc. the burden of on-boarding is reduced.

# Pre-requistes

## Docker

Go to Docker.io and download and install the latest installer. On MacOS use the docker for Mac.

## About using Brew to install docker

Using the native #Docker Desktop for Mac# is now preferable then using the older Docker Toolbox. Though for Devops disable the Kubernetes integration.

Installing Docker via Brew

* `brew install docker`
* `brew install docker-machine`
* `brew install docker-compose`

A VM Provider is required as well. Oracle's Virtual Box is well supported.

Once VirtualBox is installed.  Create you default virtual machine

* `docker-machine create default`

### Starting Docker
### Update local shell configuration

Just use Docker for Mac instead

## AWS ECR Integration

Follow the directions at these two locations to install the AWS ClI and ECR helper with integration

* https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html
* https://github.com/awslabs/amazon-ecr-credential-helper


Use the following to update `~/.docker/config.json`
```
{
  "credHelpers" : {
    "011447054295.dkr.ecr.us-west-2.amazonaws.com" : "ecr-login"
  }
}
```

##  AWS Authentication

NOTE:  All of the containers rely on your AWS credentials.

Make sure you've done 'saml2aws login' already

# Container Details

The configuration is divided across a couple of containers

## Base Tooling

Run `build-base.sh` to create a base container that has all of the necessary tooling to run the devops-application

Tools included are,

* Python
* Terraform
* Kubectl
* AWS IAM Authenticator for Kubernetes
* JQ

## EKS For Developers

Create an EKS cluster that is private for you to use.  The cluster is named using your paxata account name and resides in US-WEST-2

The command is `./developer-eks.sh`


## EKS for Production

This creates a cluster in US-EAST-1.  Be sure you are authenticated to production before use.

The command is `./production-eks.sh`



## EKS for developing Devops-Application

Run your updates to devops application in the same container that is used to deploy.

### Create your container locally,

The command is `./build-interactive.sh`  

Then to start the image and ssh into the container use...

The command is `./interactive.sh`

# Trouble Shooting

If you would like to enter the image you created and check it out...
>  docker run -it --entrypoint /bin/bash <image-name>

# Advanced

In order to use a specific image that you would like to pull from DTR/ECR

Also login into ECR: aws ecr get-login --region us-west-2 --no-include-email  (paste and run the 'docker login' command.

docker run -v '/Users/YOUR_HOME_DIRECTORY/.aws':'/root/.aws' -e GITUSER=paxata-github -e GITPASSWORD=OUR_GIT_PASSWORD -e ID=NAME_OF_CLUSTER -e ACTION=up 011447054295.dkr.ecr.us-west-2.amazonaws.com/paxinstall:lateast


No need to build if you are using the ECR image above but if you want your own copy:

docker build -t paxinstall .

## Troubleshooting

if build.sh hangs

```
<-------------> 0% EXECUTING [1m 4s]
> :buildImage
```

* Validate the docker machine is running

`Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?`

run:  `eval "$(docker-machine env default)"`

`Error checking TLS connection: Host is not running`

run: `docker-machine start`

## When using the AWS ECR Cred Helper

NOTE: doing this breaks the `aws ecr get-login` method

Copy the config.json file to  `~/.docker/config.json`

### Add certificate chain to Java

tried this but still fails

Tried this in Open Java 12 ` brew cask install java`

Updating the keystore located at `/Library/Java/JavaVirtualMachines/openjdk-12.0.2.jdk/Contents/Home/lib/security`

This gets all of the certificates and the entire chain
```
openssl s_client -connect 011447054295.dkr.ecr.us-west-2.amazonaws.com:443 </dev/null -prexit -showcerts | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > amazon.cert
```

Then Import...
```
sudo keytool -importcert -alias amazon -file amazon.cert -cacerts
```

password is changeit.  

AWS to ECR helper,

brew install docker-credential-helper-ecr
https://github.com/awslabs/amazon-ecr-credential-helper

AWS Cert Chain

*.dkr.ecr.us-west-2.amazonaws.com
SHA1 B6 1D 88 81 3B 24 9C DD 73 C2 46 D9 2F 58 8F 20 88 55 BB 58

Amazon Root CA 1 ( intermediate )
SHA1 06 B2 59 27 C4 2A 72 16 31 C1 EF D9 43 1E 64 8F A6 2E 1E 39

Amazon ( intermediate 1B)
SHA1 91 7E 73 2D 33 0F 9A 12 40 4F 73 D8 BE A3 69 48 B9 29 DF FC

Amazon Root CA 1 (Root CA )
SHA1  8D A7 F9 65 EC 5E FC 37 91 0F 1C 6E 59 FD C1 CC 6A 6E DE 16
