FROM ubuntu:18.04

# Creating environment to install kubernetes cluster on AWS for Paxata app

ARG tf_version=0.12.4

ENV tf_version $tf_version

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

# Install JQ
#ENV JQ_VERSION='1.5'

#RUN wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/jq-release.key -O /tmp/jq-release.key && \
#    wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/v${JQ_VERSION}/jq-linux64.asc -O /tmp/jq-linux64.asc && \
#    wget --no-check-certificate https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /tmp/jq-linux64 && \
#    gpg --import /tmp/jq-release.key && \
#    gpg --verify /tmp/jq-linux64.asc /tmp/jq-linux64 && \
#    cp /tmp/jq-linux64 /usr/bin/jq && \
#    chmod +x /usr/bin/jq && \
#    rm -f /tmp/jq-release.key && \
#    rm -f /tmp/jq-linux64.asc && \
#    rm -f /tmp/jq-linux64

# Install Ansible
#RUN pip3 install ansible

# Install SAML2AWS
#ARG GO_FILE=go1.9.linux-amd64.tar.gz
#RUN cd /tmp; curl -O https://storage.googleapis.com/golang/$GO_FILE
#RUN cd /tmp; tar -xvf $GO_FILE; mv go /usr/local; rm -f $GO_FILE
#ENV PATH $PATH:/usr/local/go/bin:/go/bin
#ENV GOROOT /usr/local/go
#ENV GOPATH /go
#ARG BASEDIR=$GOPATH/src/github.com/versent
#RUN mkdir -p $BASEDIR; cd $BASEDIR; git clone https://github.com/Versent/saml2aws.git
#RUN cd $BASEDIR/saml2aws; make deps
#RUN cd $BASEDIR/saml2aws; make install

# Create dir for .aws credentials
RUN mkdir /root/.aws
#COPY credentials /root/.aws

#ARG GITUSER
#ARG GITPASSWORD

# Pull down the infra code
#RUN git clone https://$GITUSER:$GITPASSWORD@github.com/Paxata/devops-application.git

#RUN git config user.email test@github.com
#WORKDIR /devops-application/infrastructure
#CMD ./developer-eks.sh up
