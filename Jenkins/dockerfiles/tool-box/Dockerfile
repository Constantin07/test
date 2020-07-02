FROM alpine:3.12.0 AS builder

ARG INSTALL_DIR="/usr/local/bin"

ARG TERRAFORM_VERSION=0.12.28
ARG TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG TERRAFORM_FILE="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG TERRAFORM_SHA256="be99da1439a60942b8d23f63eba1ea05ff42160744116e84f46fc24f1a8011b6"

ARG PACKER_VERSION=1.6.0
ARG PACKER_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
ARG PACKER_FILE="packer_${PACKER_VERSION}_linux_amd64.zip"
ARG PACKER_SHA256="a678c995cb8dc232db3353881723793da5acc15857a807d96c52e96e671309d9"

ARG KUBECTL_VERSION=v1.18.5
ARG KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
ARG KUBECTL_FILE="kubectl"
ARG KUBECTL_SHA256="69d9b044ffaf544a4d1d4b40272f05d56aaf75d7e3c526d5418d1d3c78249e45"

ARG HELM_VERSION=v3.2.4
ARG HELM_URL="https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_FILE="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_SHA256="8eb56cbb7d0da6b73cd8884c6607982d0be8087027b8ded01d6b2759a72e34b1"

ARG HELMFILE_VERSION=0.120.0
ARG HELMFILE_URL="https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64"
ARG HELMFILE_FILE="helmfile_linux_amd64"
ARG HELMFILE_SHA256="ffe0482d03782a8c33ab75bde18a1ba221597b886d08da758dd33ec5a3753a4a"

ARG GOMPLATE_VERSION=3.7.0
ARG GOMPLATE_URL="https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64"
ARG GOMPLATE_FILE="gomplate_linux-amd64"
ARG GOMPLATE_SHA256="27b0792309b78cd872ffe72a040475b2704f72e055a774079c9fcc5ac23543f6"

ARG VALIDATEYAML_VERSION=v0.2.3
ARG VALIDATEYAML_URL="https://github.com/gerald1248/validate-yaml/releases/download/${VALIDATEYAML_VERSION}/validate-yaml-linux-amd64.zip"
ARG VALIDATEYAML_FILE="validate-yaml-${VALIDATEYAML_VERSION}-linux-amd64.zip"
ARG VALIDATEYAML_SHA256="9cc6be3b29d25ad79fd7e3ed4397a6320f8c31939c5a0575c077b47ee41b6db2"

ARG KUBEVAL_VERSION=0.15.0
ARG KUBEVAL_URL="https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz"
ARG KUBEVAL_FILE="kubeval-linux-amd64.tar.gz"
ARG KUBEVAL_SHA256="70bff2642a2886c0d9ebea452ffb81f333a956e26bbe0826fd7c6797e343e5aa"

ARG SHUNIT2_URL="https://raw.githubusercontent.com/kward/shunit2/master/shunit2"
ARG SHUNIT2_FILE="shunit2"

RUN apk --no-cache add curl unzip

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${TERRAFORM_FILE} ${TERRAFORM_URL}; \
    sha256sum ${TERRAFORM_FILE} | grep ${TERRAFORM_SHA256}; \
    unzip -d ${INSTALL_DIR} ${TERRAFORM_FILE}; \
    chmod +x ${INSTALL_DIR}/terraform

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${PACKER_FILE} ${PACKER_URL}; \
    sha256sum ${PACKER_FILE} | grep ${PACKER_SHA256}; \
    unzip -d ${INSTALL_DIR} ${PACKER_FILE}; \
    chmod +x ${INSTALL_DIR}/packer

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${KUBECTL_FILE} ${KUBECTL_URL}; \
    sha256sum ${KUBECTL_FILE} | grep ${KUBECTL_SHA256}; \
    mv ${KUBECTL_FILE} ${INSTALL_DIR}/${KUBECTL_FILE}; \
    chmod +x ${INSTALL_DIR}/${KUBECTL_FILE}

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${HELM_FILE} ${HELM_URL}; \
    sha256sum ${HELM_FILE} | grep ${HELM_SHA256}; \
    tar xvzf ${HELM_FILE} -C ${INSTALL_DIR} --strip-components=1 linux-amd64/helm

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${HELMFILE_FILE} ${HELMFILE_URL}; \
    sha256sum ${HELMFILE_FILE} | grep ${HELMFILE_SHA256}; \
    mv ${HELMFILE_FILE} ${INSTALL_DIR}/helmfile; \
    chmod +x ${INSTALL_DIR}/helmfile

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${GOMPLATE_FILE} ${GOMPLATE_URL}; \
    sha256sum ${GOMPLATE_FILE} | grep ${GOMPLATE_SHA256}; \
    mv ${GOMPLATE_FILE} ${INSTALL_DIR}/gomplate; \
    chmod +x ${INSTALL_DIR}/gomplate

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${VALIDATEYAML_FILE} ${VALIDATEYAML_URL}; \
    sha256sum ${VALIDATEYAML_FILE} | grep ${VALIDATEYAML_SHA256}; \
    mv ${VALIDATEYAML_FILE} ${INSTALL_DIR}/validate-yaml; \
    chmod +x ${INSTALL_DIR}/validate-yaml

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${KUBEVAL_FILE} ${KUBEVAL_URL}; \
    sha256sum ${KUBEVAL_FILE} | grep ${KUBEVAL_SHA256}; \
    tar xvzf ${KUBEVAL_FILE} -C ${INSTALL_DIR} kubeval

RUN set -ex; curl -fsSL --retry 3 -o ${INSTALL_DIR}/${SHUNIT2_FILE} ${SHUNIT2_URL}


FROM alpine:3.12.0

ARG USERNAME=toolbox
ENV HELM_HOME=/tmp/.helm

RUN apk update && apk upgrade && \
    apk --no-cache add ca-certificates curl bash python3 py-pip make git gnupg ansible && \
    setcap cap_net_raw+ep /bin/busybox

COPY requirements.txt /
RUN pip3 install --upgrade pip setuptools && \
    pip3 install -r /requirements.txt

RUN set -ex; curl -fsSL --retry 3 -o /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-git-crypt/master/sgerrand.rsa.pub && \
    curl -fsSL --retry 3 -O https://github.com/sgerrand/alpine-pkg-git-crypt/releases/download/0.6.0-r1/git-crypt-0.6.0-r1.apk && \
    apk add git-crypt-0.6.0-r1.apk && rm -f git-crypt-0.6.0-r1.apk && \
    ln -s /bin/git-crypt /usr/local/bin/git-crypt

# Nonprivileged user
RUN addgroup -g 992 ${USERNAME} && \
    adduser -D -u 995 -G ${USERNAME} ${USERNAME}

USER ${USERNAME}

COPY --from=builder /usr/local/bin /usr/local/bin

# Add helm repositories
RUN helm repo add stable https://kubernetes-charts.storage.googleapis.com && \
    helm repo add bitnami https://charts.bitnami.com/bitnami && \
    helm repo update
