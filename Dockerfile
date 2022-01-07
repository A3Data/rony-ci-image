FROM --platform=linux/amd64 ubuntu:latest

ARG DEBIAN_FRONTEND="noninteractive"
ARG IAMLIVE_VERSION=0.40.0
ARG TERRAFORM_VERSION=1.1.3

RUN apt update
RUN apt upgrade

## Install general tools
RUN apt-get -y install zip unzip
RUN apt-get -y install git

## Install aws cli
RUN apt -y install python3 python3-pip wget
RUN pip3 install awscli

## Install terraform
ADD ./scripts/install_terraform.sh  /install_terraform.sh
RUN chmod 755 /install_terraform.sh
RUN /install_terraform.sh ${TERRAFORM_VERSION}

## Install iamlive

ADD ./scripts/install_iamlive.sh  /install_iamlive.sh
RUN chmod 755 /install_iamlive.sh
RUN /install_iamlive.sh ${IAMLIVE_VERSION}

#
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
RUN mv "jq-linux64" "/bin/jq"
RUN chmod +x "/bin/jq"
COPY ./scripts/terraform.jq /bin/terraform.jq
COPY ./scripts/plan-cost.sh /bin/plan-cost
RUN chmod +x "/bin/terraform.jq"
RUN chmod +x "/bin/plan-cost"

#

WORKDIR "/bin/"
COPY ./scripts/entrypoint.sh .
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]