# SAML To AWS

[For additional Information](https://paxata.atlassian.net/wiki/spaces/OPS/pages/378961936/AWS+Account+Provisioning+Process)

The following describes how install and use SAML with JumpCloud to connect to AWS

## Pre-Requisites

Devops needs to add the appropriate role to your JumpCloud account

## Required installed dependencies:  

More recent versions are fine.

1. Requires the AWS-CLI
 * Python: Boto3 is required ( ? verify )

## Installation

### Install SAML2AWS

Run:  >  brew install versent/homebrew-taps/saml2aws

### Initial Setup

Run:  >  saml2aws configure

Use the arrows to choose the JumpCloud provider

Set AWS Profile to "default" overriding the default of "saml"

Set URL to "https://sso.jumpcloud.com/saml2/aws"
Note:  Or other URL as defined in JumpCloud applications

Set Username to your full paxata email ending with '@paxata.com'

Enter and confirm your existing JumpCloud password

The configuration is stored in ~/.saml2aws

###  Tweak the Config file

Open the settings file, ~/.saml2aws

#### Extend Timeout

Make "aws_session_duration = 28800"


### Log in

Run:  >  saml2aws login

You will be prompted to verify your user name and password. If they are set correctly then just press enter to accept the defaults (this inlude the password if you have logged in before)

You will then be prompted to enter your MFA token for JumpCloud.

If you receive "Your new access key pair has been stored in the AWS configuration
Note that it will expire...."

If you really want to force the login, you can run

Run:  > saml2aws login --force

## If Using an AWS Profile OTHER than 'default'

set your CLI's environment:  export AWS_PROFILE="saml"

#  Next Steps

## For Developers

[Packer and Packaging](for-developers.md)

## For Devops

[Packer and Packaging](package/README.md)

[Infrastructure](infrastructure/README.md)
