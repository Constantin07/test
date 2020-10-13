FROM alpine:3.12.0 AS builder

ARG INSTALL_DIR="/usr/local/bin"

ARG TERRAFORM_VERSION=0.13.4
ARG TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG TERRAFORM_FILE="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG TERRAFORM_SHA256="a92df4a151d390144040de5d18351301e597d3fae3679a814ea57554f6aa9b24"

ARG PACKER_VERSION=1.6.4
ARG PACKER_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
ARG PACKER_FILE="packer_${PACKER_VERSION}_linux_amd64.zip"
ARG PACKER_SHA256="a20ec68e9eb6e1d6016481003f705babbecc28e234f8434f3a35f675cb200ea8"

ARG KUBECTL_VERSION=v1.19.2
ARG KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
ARG KUBECTL_FILE="kubectl"
ARG KUBECTL_SHA256="f51adfe7968ee173dbfb3dabfc10dc774983cbf8a3a7c1c75a1423b91fda6821"

ARG HELM_VERSION=v3.3.4
ARG HELM_URL="https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_FILE="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_SHA256="b664632683c36446deeb85c406871590d879491e3de18978b426769e43a1e82c"

ARG HELMFILE_VERSION=0.130.2
ARG HELMFILE_URL="https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64"
ARG HELMFILE_FILE="helmfile_linux_amd64"
ARG HELMFILE_SHA256="82127044bbf86f4ab0e89832da64cbaed80c59c3cdd80f322257ee296aeb97e8"

ARG GOMPLATE_VERSION=3.8.0
ARG GOMPLATE_URL="https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64"
ARG GOMPLATE_FILE="gomplate_linux-amd64"
ARG GOMPLATE_SHA256="13b39916b11638b65f954fab10815e146bad3a615f14ba2025a375faf0d1107e"

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
    apk --no-cache add ca-certificates curl bash jq python3 py-pip make git gnupg ansible && \
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
RUN helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && \
    helm repo add bitnami https://charts.bitnami.com/bitnami && \
    helm repo add stable https://kubernetes-charts.storage.googleapis.com && \
    helm repo update
