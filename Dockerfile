FROM ubuntu:18.04

ARG AWS_REGION
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

RUN mkdir -p /usr/src/tmp
WORKDIR /usr/src/tmp

RUN apt-get update && apt-get install --no-install-recommends -y \
curl \
ca-certificates \
python3.8 python3.8-venv python3.8-distutils

# install python pip module
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py

# install aws cli with pip
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html#install-tool-pip
RUN pip3 install awscli --upgrade

# install eksctl
# https://eksctl.io/introduction/installation/
RUN curl --silent --location https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz | tar xz -C /tmp
RUN mv /tmp/eksctl /usr/local/bin

# install kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# install aws-iam-authenticator
# https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html#w243aac27c11b5b3
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x ./aws-iam-authenticator
RUN mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
RUN echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

# install helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

# Helm 3 no longer ships with a default chart repository
RUN helm repo add stable https://kubernetes-charts.storage.googleapis.com

# add AWS credentials
RUN mkdir $HOME/.aws
RUN touch $HOME/.aws/config
RUN touch $HOME/.aws/credentials

RUN echo "[default]\nregion = $AWS_REGION\noutput = json\n" >> $HOME/.aws/config
RUN echo "[default]\naws_access_key_id = $AWS_ACCESS_KEY_ID \naws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> $HOME/.aws/credentials