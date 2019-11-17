FROM alpine:3.10.3 AS BUILDER

ARG INSTALL_DIR="/usr/local/bin"

ARG TERRAFORM_VERSION=0.12.15
ARG TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG TERRAFORM_FILE="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG TERRAFORM_SHA256="2acb99936c32f04d0779c3aba3552d6d2a1fa32ed63cbca83a84e58714f22022"

ARG PACKER_VERSION=1.4.5
ARG PACKER_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
ARG PACKER_FILE="packer_${PACKER_VERSION}_linux_amd64.zip"
ARG PACKER_SHA256="30da8dab9c526a6d15b037e2234f6f12cf3accfad77eb2c130738ec1a54cab6d"

ARG KUBECTL_VERSION=v1.16.2
ARG KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
ARG KUBECTL_FILE="kubectl"
ARG KUBECTL_SHA256="3ff48e12f9c768ad548e4221d805281ea28dfcda5c18b3cd1797fe37aee3012e"

ARG HELM_VERSION=2.16.1
ARG HELM_URL="https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_SHA256="7eebaaa2da4734242bbcdced62cc32ba8c7164a18792c8acdf16c77abffce202"

ARG HELMFILE_VERSION=0.90.9
ARG HELMFILE_URL="https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64"
ARG HELMFILE_FILE="helmfile_linux_amd64"
ARG HELMFILE_SHA256="5fd5c87341dba9aa0e6439cd69bfc303696c700f87a4ac8c17044a6311f5e8a1"

ARG GOMPLATE_VERSION=3.6.0
ARG GOMPLATE_URL="https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64"
ARG GOMPLATE_FILE="gomplate_linux-amd64"
ARG GOMPLATE_SHA256="0ec9907db0e31842d954e7644c928d1b5e0eaf0f112096a0fc0d923de34cb704"

ARG VALIDATEYAML_VERSION=v0.2.3
ARG VALIDATEYAML_URL="https://github.com/gerald1248/validate-yaml/releases/download/${VALIDATEYAML_VERSION}/validate-yaml-linux-amd64.zip"
ARG VALIDATEYAML_FILE="validate-yaml-${VALIDATEYAML_VERSION}-linux-amd64.zip"
ARG VALIDATEYAML_SHA256="9cc6be3b29d25ad79fd7e3ed4397a6320f8c31939c5a0575c077b47ee41b6db2"

ARG KUBEVAL_VERSION=0.14.0
ARG KUBEVAL_URL="https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz"
ARG KUBEVAL_FILE="kubeval-linux-amd64.tar.gz"
ARG KUBEVAL_SHA256="8b1b8c63df9ee3206113a3352e07474ea071610cfacf40a64db74c56e163f1e2"

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


FROM alpine:3.10.3

ARG AWSCLI_VERSION=1.16.282

ENV HELM_HOME=/tmp/.helm

RUN apk update && apk upgrade && \
    apk --no-cache add ca-certificates curl bash python3 make git gnupg ansible && \
    pip3 install --upgrade pip setuptools && \
    pip3 install awscli==${AWSCLI_VERSION}

RUN set -ex; curl -fsSL --retry 3 -o /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-git-crypt/master/sgerrand.rsa.pub && \
    curl -fsSL --retry 3 -O https://github.com/sgerrand/alpine-pkg-git-crypt/releases/download/0.6.0-r1/git-crypt-0.6.0-r1.apk && \
    apk add git-crypt-0.6.0-r1.apk && rm -f git-crypt-0.6.0-r1.apk && \
    ln -s /bin/git-crypt /usr/local/bin/git-crypt

# Nonprivileged user
RUN addgroup -g 992 toolbox && \
    adduser -D -u 995 -G toolbox toolbox

USER toolbox

COPY --from=BUILDER /usr/local/bin /usr/local/bin
