FROM alpine:3.9.4 AS BUILDER

ARG INSTALL_DIR="/usr/local/bin"

ARG TERRAFORM_VERSION=0.11.14
ARG TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG TERRAFORM_FILE="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG TERRAFORM_SHA256="9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd"

ARG PACKER_VERSION=1.4.1
ARG PACKER_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
ARG PACKER_FILE="packer_${PACKER_VERSION}_linux_amd64.zip"
ARG PACKER_SHA256="b713ea79a6fb131e27d65ec3f2227f36932540e71820288c3c5ad770b565ecd7"

ARG HELM_VERSION=2.14.0
ARG HELM_URL="https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_SHA256="b5f6a1e642971af1363cadbe1f7f37c029c11dd93813151b521c0dbeacfbdaa9"

ARG HELMFILE_VERSION=0.64.1
ARG HELMFILE_URL="https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64"
ARG HELMFILE_FILE="helmfile_linux_amd64"
ARG HELMFILE_SHA256="ce52ae1fd7fe3fd4960ba7f9e9df759671c267387db8ba9e70c1a8e5c1a4abaf"

RUN apk --no-cache add curl unzip

RUN set -ex; curl -sS -L -o ${TERRAFORM_FILE} ${TERRAFORM_URL}; \
    sha256sum ${TERRAFORM_FILE} | grep ${TERRAFORM_SHA256}; \
    unzip -d ${INSTALL_DIR} ${TERRAFORM_FILE}; \
    chmod +x ${INSTALL_DIR}/terraform

RUN set -ex; curl -sS -L -o ${PACKER_FILE} ${PACKER_URL}; \
    sha256sum ${PACKER_FILE} | grep ${PACKER_SHA256}; \
    unzip -d ${INSTALL_DIR} ${PACKER_FILE}; \
    chmod +x ${INSTALL_DIR}/packer

RUN set -ex; curl -sS -L -o ${HELM_FILE} ${HELM_URL}; \
    sha256sum ${HELM_FILE} | grep ${HELM_SHA256}; \
    tar xvzf ${HELM_FILE} -C ${INSTALL_DIR} --strip-components=1 linux-amd64/helm

RUN set -ex; curl -sS -L -o ${HELMFILE_FILE} ${HELMFILE_URL}; \
    sha256sum ${HELMFILE_FILE} | grep ${HELMFILE_SHA256}; \
    mv ${HELMFILE_FILE} ${INSTALL_DIR}/helmfile; \
    chmod +x ${INSTALL_DIR}/helmfile


FROM alpine:3.9.4

ARG AWSCLI_VERSION=1.16.163

RUN apk --no-cache add ca-certificates python3 && \
    pip3 install --upgrade pip setuptools && \
    pip3 install awscli==${AWSCLI_VERSION}

COPY --from=BUILDER /usr/local/bin /usr/local/bin
