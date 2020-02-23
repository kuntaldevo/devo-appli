
Steps to install AWS authenticator on MacOs

Can be performed in any directory

Consult [AWS Reference](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html) to get the latest

Download the latest authenticator.

>  curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/darwin/amd64/aws-iam-authenticator

Apply execute permissions to the binary.

>  chmod +x ./aws-iam-authenticator

Move the binary to your PATH

> mv ./aws-iam-authenticator /usr/local/bin/

Test that the aws-iam-authenticator binary works.

>  aws-iam-authenticator help
