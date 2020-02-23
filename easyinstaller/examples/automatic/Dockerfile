FROM ubuntu:18.04

ARG tf_version=0.12.4

ENV tf_version $tf_version

# Creating environment to install kubernetes cluster on AWS for Paxata app

# Install Python and tools
RUN apt-get update && apt-get install -yqq \
    wget \
    git \
    python3.5 \
    python3-pip \
    curl \
    unzip \
  && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN wget --quiet https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_amd64.zip -O terraform.zip \
  && unzip terraform.zip \
  && mv terraform /usr/bin \
  && rm terraform.zip

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

# Install JQ
ENV JQ_VERSION='1.5'

RUN wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/jq-release.key -O /tmp/jq-release.key && \
    wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/v${JQ_VERSION}/jq-linux64.asc -O /tmp/jq-linux64.asc && \
    wget --no-check-certificate https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /tmp/jq-linux64 && \
    gpg --import /tmp/jq-release.key && \
    gpg --verify /tmp/jq-linux64.asc /tmp/jq-linux64 && \
    cp /tmp/jq-linux64 /usr/bin/jq && \
    chmod +x /usr/bin/jq && \
    rm -f /tmp/jq-release.key && \
    rm -f /tmp/jq-linux64.asc && \
    rm -f /tmp/jq-linux64

RUN mkdir /root/.aws

#Install SSH Deploy Key
RUN mkdir /root/.ssh
COPY ssh-settings/docker.devops-app.deploy-key.id_rsa /root/.ssh/id_rsa
COPY ssh-settings/docker.devops-app.deploy-key.id_rsa.pub /root/.ssh/id_rsa.pub
COPY ssh-settings/ssh-config /root/.ssh/config
RUN chown -R root:root /root/.ssh
RUN chmod -R 0400 /root/.ssh

COPY startup.sh /root
RUN chmod -R 0777 /root/startup.sh


# Run the startup code
ENTRYPOINT ["/root/startup.sh"]
