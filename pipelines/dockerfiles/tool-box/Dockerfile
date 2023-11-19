# syntax=docker/dockerfile:1

#checkov:skip=CKV_DOCKER_2: No healcheck is required for this image

ARG VAULT_CERTS=copy

FROM alpine:3.18 AS builder

RUN apk --no-cache add curl unzip

ARG INSTALL_DIR="/usr/local/bin"

ARG TERRAFORM_VERSION=1.6.4
ARG TERRAFORM_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
ARG TERRAFORM_FILE=terraform_${TERRAFORM_VERSION}_linux_amd64.zip
ARG TERRAFORM_SHA256=569fc3d526dcf57eb5af4764843b87b36a7cb590fc50f94a07757c1189256775

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${TERRAFORM_FILE} ${TERRAFORM_URL}; \
    sha256sum ${TERRAFORM_FILE} | grep ${TERRAFORM_SHA256}; \
    unzip -d ${INSTALL_DIR} ${TERRAFORM_FILE}; \
    chmod +x ${INSTALL_DIR}/terraform

ARG KUBECTL_VERSION=v1.28.2
ARG KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
ARG KUBECTL_FILE=kubectl
ARG KUBECTL_SHA256=c922440b043e5de1afa3c1382f8c663a25f055978cbc6e8423493ec157579ec5

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${KUBECTL_FILE} ${KUBECTL_URL}; \
    sha256sum ${KUBECTL_FILE} | grep ${KUBECTL_SHA256}; \
    mv ${KUBECTL_FILE} ${INSTALL_DIR}/${KUBECTL_FILE}; \
    chmod +x ${INSTALL_DIR}/${KUBECTL_FILE}

ARG HELM_VERSION=v3.13.2
ARG HELM_URL=https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz
ARG HELM_FILE=helm-${HELM_VERSION}-linux-amd64.tar.gz
ARG HELM_SHA256=55a8e6dce87a1e52c61e0ce7a89bf85b38725ba3e8deb51d4a08ade8a2c70b2d

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${HELM_FILE} ${HELM_URL}; \
    sha256sum ${HELM_FILE} | grep ${HELM_SHA256}; \
    tar xvzf ${HELM_FILE} -C ${INSTALL_DIR} --strip-components=1 linux-amd64/helm

ARG HELMFILE_VERSION=0.158.1
ARG HELMFILE_URL=https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz
ARG HELMFILE_FILE=helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz
ARG HELMFILE_SHA256=b8843105157d4281847f54c35a3100afce4175a8b44a3539d54f9194f5497162

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${HELMFILE_FILE} ${HELMFILE_URL}; \
    sha256sum ${HELMFILE_FILE} | grep ${HELMFILE_SHA256}; \
    tar -xvzf ${HELMFILE_FILE} -C ${INSTALL_DIR} helmfile; \
    chmod +x ${INSTALL_DIR}/helmfile

ARG GOMPLATE_VERSION=3.11.6
ARG GOMPLATE_URL=https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64
ARG GOMPLATE_FILE=gomplate_linux-amd64
ARG GOMPLATE_SHA256=7ce8f9f89a0b21fac05b8412af4dd8a06f9e5d8a2df70370549d2dde5f9f0d75

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${GOMPLATE_FILE} ${GOMPLATE_URL}; \
    sha256sum ${GOMPLATE_FILE} | grep ${GOMPLATE_SHA256}; \
    mv ${GOMPLATE_FILE} ${INSTALL_DIR}/gomplate; \
    chmod +x ${INSTALL_DIR}/gomplate

ARG VALIDATEYAML_VERSION=v0.2.3
ARG VALIDATEYAML_URL=https://github.com/gerald1248/validate-yaml/releases/download/${VALIDATEYAML_VERSION}/validate-yaml-linux-amd64.zip
ARG VALIDATEYAML_FILE=validate-yaml-${VALIDATEYAML_VERSION}-linux-amd64.zip
ARG VALIDATEYAML_SHA256=9cc6be3b29d25ad79fd7e3ed4397a6320f8c31939c5a0575c077b47ee41b6db2

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${VALIDATEYAML_FILE} ${VALIDATEYAML_URL}; \
    sha256sum ${VALIDATEYAML_FILE} | grep ${VALIDATEYAML_SHA256}; \
    mv ${VALIDATEYAML_FILE} ${INSTALL_DIR}/validate-yaml; \
    chmod +x ${INSTALL_DIR}/validate-yaml

ARG KUBECONFORM_VERSION=v0.6.4
ARG KUBECONFORM_URL=https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz
ARG KUBECONFORM_FILE=kubeconform-linux-amd64.tar.gz
ARG KUBECONFORM_SHA256=2b4ebeaa4d5ac4843cf8f7b7e66a8874252b6b71bc7cbfc4ef1cbf85acec7c07

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${KUBECONFORM_FILE} ${KUBECONFORM_URL}; \
    sha256sum ${KUBECONFORM_FILE} | grep ${KUBECONFORM_SHA256}; \
    tar xvzf ${KUBECONFORM_FILE} -C ${INSTALL_DIR} kubeconform

ARG ECR_HELPER_VERSION=0.7.0
ARG ECR_HELPER_URL=https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${ECR_HELPER_VERSION}/linux-amd64/docker-credential-ecr-login
ARG ECR_HELPER_FILE=docker-credential-ecr-login
ARG ECR_HELPER_SHA256=c978912da7f54eb3bccf4a3f990c91cc758e1494a8af7a60f3faf77271b565db

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${INSTALL_DIR}/${ECR_HELPER_FILE} ${ECR_HELPER_URL}; \
    sha256sum ${INSTALL_DIR}/${ECR_HELPER_FILE} | grep ${ECR_HELPER_SHA256}; \
    chmod +x ${INSTALL_DIR}/${ECR_HELPER_FILE}

ARG GITCHGLOG_VERSION=0.15.4
ARG GITCHGLOG_URL=https://github.com/git-chglog/git-chglog/releases/download/v${GITCHGLOG_VERSION}/git-chglog_${GITCHGLOG_VERSION}_linux_amd64.tar.gz
ARG GITCHGLOG_FILE=git-chglog_${GITCHGLOG_VERSION}_linux_amd64.tar.gz
ARG GITCHGLOG_SHA256=03cbeedbd1317289295e75016fa0acd26baeb2fc7810ed287361dd9bd8bc33a8

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${GITCHGLOG_FILE} ${GITCHGLOG_URL}; \
    sha256sum ${GITCHGLOG_FILE} | grep ${GITCHGLOG_SHA256}; \
    tar -xvzf ${GITCHGLOG_FILE} -C ${INSTALL_DIR} git-chglog

ARG SHUNIT2_URL=https://raw.githubusercontent.com/kward/shunit2/master/shunit2
ARG SHUNIT2_FILE=shunit2

RUN set -ex; curl -fsSL --retry 3 -o ${INSTALL_DIR}/${SHUNIT2_FILE} ${SHUNIT2_URL}

# Add ansible galaxy dependencies
COPY requirements.yml .
RUN apk --no-cache add ansible && \
    ansible-galaxy collection install -r requirements.yml


FROM alpine:3.18 as certs_copy
ONBUILD RUN apk --no-cache update && apk --no-cache add ca-certificates
ONBUILD COPY *_ca.crt /usr/local/share/ca-certificates/

FROM alpine:3.18 as certs_no_copy
ONBUILD RUN apk --no-cache update && apk --no-cache add ca-certificates

#checkov:skip=CKV_DOCKER_7: Using multistage build images with no version tags
FROM certs_${VAULT_CERTS} as certs


FROM alpine:3.18

ARG USERNAME=toolbox
ENV USER=${USERNAME} \
    HELM_HOME=/tmp/.helm \
    PYTHONUNBUFFERED=1 \
    AWS_DEFAULT_REGION=eu-west-1

# Keep Ansible output colorized
ENV ANSIBLE_FORCE_COLOR=true \
    ANSIBLE_HOST_KEY_CHECKING=False

COPY requirements.txt /
COPY --from=certs /usr/local/share/ca-certificates/ /usr/local/share/ca-certificates/

RUN apk --no-cache update && apk --no-cache upgrade && \
    apk --no-cache add ca-certificates git curl bash procps jq python3 py3-pip make openssh-client openssl gnupg git-crypt && \
    apk --no-cache add --virtual build-dependencies python3-dev libffi-dev musl-dev gcc openssl-dev libcap && \
    setcap cap_net_raw+ep /bin/busybox && \
    pip3 install --no-cache-dir --upgrade setuptools && \
    pip3 install --no-cache-dir --upgrade --ignore-installed pip && \
    pip3 install --no-cache-dir -r /requirements.txt && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* /root/.cache/pip && \
    update-ca-certificates

RUN ln -s /usr/bin/git-crypt /usr/local/bin/git-crypt

# Add non-privileged user
RUN addgroup -g 113 ${USERNAME} && \
    adduser -D -h /home/${USERNAME} -u 109 -G ${USERNAME} ${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder --chown=${USERNAME} /root/.ansible .ansible

RUN mkdir -p /home/${USERNAME}/.docker
COPY --chown=${USERNAME}:${USERNAME} config.json /home/${USERNAME}/.docker/

# Other common binaries
COPY bin/* /usr/local/bin/
