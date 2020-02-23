FROM ubuntu:18.04

# Create a basic container with all of the tooling needed to deploy and develop etc

# Install Python and tools
RUN apt-get update && apt-get install -yqq \
    wget \
    git \
    python3.5 \
    python3-pip \
    curl \
    unzip \
    util-linux \
    jq \
    oathtool \
  && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN wget --quiet https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip \
  && unzip terraform_0.11.14_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_0.11.14_linux_amd64.zip

ENV PATH="/root/.local/bin:${PATH}"

# Install AwsCli
RUN pip3 install awscli --upgrade --user

# Install Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin
RUN mkdir -p kube
ENV KUBECONFIG=/kube/config

# Install Aws-iam-authenticator
RUN curl -L https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator -o /usr/local/bin/aws-iam-authenticator
RUN chmod +x /usr/local/bin/aws-iam-authenticator
