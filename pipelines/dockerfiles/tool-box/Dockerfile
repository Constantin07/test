# syntax=docker/dockerfile:1

#checkov:skip=CKV_DOCKER_2: No healcheck is required for this image

ARG VAULT_CERTS=copy

FROM alpine:3.20 AS builder

RUN apk --no-cache add curl unzip

ARG INSTALL_DIR="/usr/local/bin"

ARG TERRAFORM_VERSION=1.9.7
ARG TERRAFORM_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
ARG TERRAFORM_FILE=terraform_${TERRAFORM_VERSION}_linux_amd64.zip
ARG TERRAFORM_SHA256=76a77ed7e785ef354b7f565abaa990e3e7b5232d3ec4afb87e0f5a413fcbdad1

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${TERRAFORM_FILE} ${TERRAFORM_URL}; \
    sha256sum ${TERRAFORM_FILE} | grep ${TERRAFORM_SHA256}; \
    unzip -d ${INSTALL_DIR} ${TERRAFORM_FILE}; \
    chmod +x ${INSTALL_DIR}/terraform

ARG KUBECTL_VERSION=v1.30.5
ARG KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
ARG KUBECTL_FILE=kubectl
ARG KUBECTL_SHA256=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${KUBECTL_FILE} ${KUBECTL_URL}; \
    sha256sum ${KUBECTL_FILE} | grep ${KUBECTL_SHA256}; \
    mv ${KUBECTL_FILE} ${INSTALL_DIR}/${KUBECTL_FILE}; \
    chmod +x ${INSTALL_DIR}/${KUBECTL_FILE}

ARG HELM_VERSION=v3.16.0
ARG HELM_URL=https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz
ARG HELM_FILE=helm-${HELM_VERSION}-linux-amd64.tar.gz
ARG HELM_SHA256=327cfbc7ddc5a3eb644039ceb0cff66394628654c4f5a76bf715ed15b893983b

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${HELM_FILE} ${HELM_URL}; \
    sha256sum ${HELM_FILE} | grep ${HELM_SHA256}; \
    tar xvzf ${HELM_FILE} -C ${INSTALL_DIR} --strip-components=1 linux-amd64/helm

ARG HELMFILE_VERSION=0.167.1
ARG HELMFILE_URL=https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz
ARG HELMFILE_FILE=helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz
ARG HELMFILE_SHA256=245bfb3dae5df1c0a45a5e255d06823da98b0b41267dade84ae6815707c93315

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${HELMFILE_FILE} ${HELMFILE_URL}; \
    sha256sum ${HELMFILE_FILE} | grep ${HELMFILE_SHA256}; \
    tar -xvzf ${HELMFILE_FILE} -C ${INSTALL_DIR} helmfile; \
    chmod +x ${INSTALL_DIR}/helmfile

ARG GOMPLATE_VERSION=4.1.0
ARG GOMPLATE_URL=https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64
ARG GOMPLATE_FILE=gomplate_linux-amd64
ARG GOMPLATE_SHA256=0f5c89747e6b838cc5b7e8371eda0582388edebf7a4878e84de92a7f4a7f82a6

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

ARG KUBECONFORM_VERSION=v0.6.7
ARG KUBECONFORM_URL=https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz
ARG KUBECONFORM_FILE=kubeconform-linux-amd64.tar.gz
ARG KUBECONFORM_SHA256=95f14e87aa28c09d5941f11bd024c1d02fdc0303ccaa23f61cef67bc92619d73

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${KUBECONFORM_FILE} ${KUBECONFORM_URL}; \
    sha256sum ${KUBECONFORM_FILE} | grep ${KUBECONFORM_SHA256}; \
    tar xvzf ${KUBECONFORM_FILE} -C ${INSTALL_DIR} kubeconform

# ARG ECR_HELPER_VERSION=0.7.0
# ARG ECR_HELPER_URL=https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${ECR_HELPER_VERSION}/linux-amd64/docker-credential-ecr-login
# ARG ECR_HELPER_FILE=docker-credential-ecr-login
# ARG ECR_HELPER_SHA256=c978912da7f54eb3bccf4a3f990c91cc758e1494a8af7a60f3faf77271b565db

# RUN set -exo pipefail; curl -fsSL --retry 3 -o ${INSTALL_DIR}/${ECR_HELPER_FILE} ${ECR_HELPER_URL}; \
#     sha256sum ${INSTALL_DIR}/${ECR_HELPER_FILE} | grep ${ECR_HELPER_SHA256}; \
#     chmod +x ${INSTALL_DIR}/${ECR_HELPER_FILE}

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


FROM alpine:3.20 as certs_copy
ONBUILD RUN apk --no-cache update && apk --no-cache add ca-certificates
ONBUILD COPY *_ca.crt /usr/local/share/ca-certificates/


FROM alpine:3.20 as certs_no_copy
ONBUILD RUN apk --no-cache update && apk --no-cache add ca-certificates


#checkov:skip=CKV_DOCKER_7: Using multistage build images with no version tags
FROM certs_${VAULT_CERTS} as certs


FROM alpine:3.20

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
    pip3 install --no-cache-dir --upgrade setuptools --break-system-packages && \
    pip3 install --no-cache-dir --upgrade --ignore-installed pip --break-system-packages && \
    pip3 install --no-cache-dir -r /requirements.txt --break-system-packages && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* /root/.cache/pip && \
    update-ca-certificates

RUN ln -s /usr/bin/git-crypt /usr/local/bin/git-crypt

# Add non-privileged user
RUN addgroup -g 113 ${USERNAME} && \
    adduser -D -h /home/${USERNAME} -u 109 -G ${USERNAME} ${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Add ansible galaxy dependencies
COPY --chown=${USERNAME}:${USERNAME} requirements.yml .
RUN ansible-galaxy collection install -r ./requirements.yml

COPY --from=builder --chown=${USERNAME} /usr/local/bin /usr/local/bin

RUN mkdir -p /home/${USERNAME}/.docker
COPY --chown=${USERNAME}:${USERNAME} config.json /home/${USERNAME}/.docker/

# Other common binaries
COPY --chown=${USERNAME}:${USERNAME} bin/* /usr/local/bin/
