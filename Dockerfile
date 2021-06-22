FROM ubuntu:latest

ARG DEBIAN_FRONTEND="noninteractive"
ARG IAMLIVE_VERSION=0.38.0

ARG GO_VERSION=1.16.5
RUN apt update

## Install terraform

RUN apt-get install -y gnupg software-properties-common curl wget
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update && apt-get install terraform

## Install iamlive
### Install go
RUN wget -c https://golang.org/dl/go1.16.5.linux-amd64.tar.gz -O - | tar -xz -C /usr/local
ENV PATH="$PATH:/usr/local/go/bin"
ENV GOBIN=/bin/ 

### Download and install iamlive
RUN wget https://github.com/iann0036/iamlive/archive/refs/tags/v${IAMLIVE_VERSION}.tar.gz
RUN tar -xzf v${IAMLIVE_VERSION}.tar.gz && rm v${IAMLIVE_VERSION}.tar.gz

WORKDIR "$PWD/iamlive-${IAMLIVE_VERSION}"
RUN go install

#
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
RUN mv "jq-linux64" "/bin/jq"
RUN chmod +x "/bin/jq"
COPY terraform.jq /home/appuser/terraform.jq
#

RUN useradd -ms /bin/bash appuser
RUN mkdir /home/appuser/.iamlive
RUN chown "appuser" "/home/appuser/.iamlive"
RUN mkdir /home/appuser/output
RUN chown "appuser" "/home/appuser/output"

WORKDIR "/bin/"
COPY entrypoint.sh .
RUN chown "appuser" "./entrypoint.sh"
RUN chmod +x ./entrypoint.sh

EXPOSE 10080

ENV AWS_CSM_ENABLED=true
ENV AWS_CSM_PORT=31000
ENV AWS_CSM_HOST=127.0.0.1
# ENV HTTP_PROXY=http://127.0.0.1:10080
# ENV HTTPS_PROXY=http://127.0.0.1:10080
# ENV AWS_CA_BUNDLE=/home/appuser/.iamlive/ca.pem

USER "appuser"

EXPOSE 10080
ENTRYPOINT ["/bin/entrypoint.sh"]