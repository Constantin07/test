FROM alpine:3.15 AS builder

RUN apk --no-cache add curl unzip

ARG INSTALL_DIR="/usr/local/bin"

ARG TERRAFORM_VERSION=1.0.11
ARG TERRAFORM_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
ARG TERRAFORM_FILE=terraform_${TERRAFORM_VERSION}_linux_amd64.zip
ARG TERRAFORM_SHA256=eeb46091a42dc303c3a3c300640c7774ab25cbee5083dafa5fd83b54c8aca664

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${TERRAFORM_FILE} ${TERRAFORM_URL}; \
    sha256sum ${TERRAFORM_FILE} | grep ${TERRAFORM_SHA256}; \
    unzip -d ${INSTALL_DIR} ${TERRAFORM_FILE}; \
    chmod +x ${INSTALL_DIR}/terraform

# ARG PACKER_VERSION=1.7.7
# ARG PACKER_URL=https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
# ARG PACKER_FILE=packer_${PACKER_VERSION}_linux_amd64.zip
# ARG PACKER_SHA256=8513c3679d51141c39da3d95c691fcfc4b2ccc20e96ac5244b58b98899d6fe54

# RUN set -exo pipefail; curl -fsSL --retry 3 -o ${PACKER_FILE} ${PACKER_URL}; \
#    sha256sum ${PACKER_FILE} | grep ${PACKER_SHA256}; \
#    unzip -d ${INSTALL_DIR} ${PACKER_FILE}; \
#    chmod +x ${INSTALL_DIR}/packer

ARG KUBECTL_VERSION=v1.21.7
ARG KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
ARG KUBECTL_FILE=kubectl
ARG KUBECTL_SHA256=d25d6b6f67456cc059680e7443c424eb613d9e840850a7be5195cff73fed41b8

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${KUBECTL_FILE} ${KUBECTL_URL}; \
    sha256sum ${KUBECTL_FILE} | grep ${KUBECTL_SHA256}; \
    mv ${KUBECTL_FILE} ${INSTALL_DIR}/${KUBECTL_FILE}; \
    chmod +x ${INSTALL_DIR}/${KUBECTL_FILE}

ARG HELM_VERSION=v3.7.1
ARG HELM_URL=https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz
ARG HELM_FILE=helm-${HELM_VERSION}-linux-amd64.tar.gz
ARG HELM_SHA256=6cd6cad4b97e10c33c978ff3ac97bb42b68f79766f1d2284cfd62ec04cd177f4

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${HELM_FILE} ${HELM_URL}; \
    sha256sum ${HELM_FILE} | grep ${HELM_SHA256}; \
    tar xvzf ${HELM_FILE} -C ${INSTALL_DIR} --strip-components=1 linux-amd64/helm

ARG HELMFILE_VERSION=v0.142.0
ARG HELMFILE_URL=https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64
ARG HELMFILE_FILE=helmfile_linux_amd64
ARG HELMFILE_SHA256=ec01b884cbb9d072f4a6784b33a29f3311248e85e714ebacabba85a79a3ba3db

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${HELMFILE_FILE} ${HELMFILE_URL}; \
    sha256sum ${HELMFILE_FILE} | grep ${HELMFILE_SHA256}; \
    mv ${HELMFILE_FILE} ${INSTALL_DIR}/helmfile; \
    chmod +x ${INSTALL_DIR}/helmfile

ARG GOMPLATE_VERSION=3.10.0
ARG GOMPLATE_URL=https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64
ARG GOMPLATE_FILE=gomplate_linux-amd64
ARG GOMPLATE_SHA256=eec0f85433c9c8aad93e8cd84c79d238f436b3e62f35b15471f5929bc741763a

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

ARG KUBEVAL_VERSION=v0.16.1
ARG KUBEVAL_URL=https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz
ARG KUBEVAL_FILE=kubeval-linux-amd64.tar.gz
ARG KUBEVAL_SHA256=2d6f9bda1423b93787fa05d9e8dfce2fc1190fefbcd9d0936b9635f3f78ba790

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${KUBEVAL_FILE} ${KUBEVAL_URL}; \
    sha256sum ${KUBEVAL_FILE} | grep ${KUBEVAL_SHA256}; \
    tar xvzf ${KUBEVAL_FILE} -C ${INSTALL_DIR} kubeval

ARG ECR_HELPER_VERSION=0.5.0
ARG ECR_HELPER_URL=https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${ECR_HELPER_VERSION}/linux-amd64/docker-credential-ecr-login
ARG ECR_HELPER_FILE=docker-credential-ecr-login
ARG ECR_HELPER_SHA256=a0ae9a66b1f41f3312785ec5e17404c7fd2a16a35703c9ea7c050406e20fc503

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${INSTALL_DIR}/${ECR_HELPER_FILE} ${ECR_HELPER_URL}; \
    sha256sum ${INSTALL_DIR}/${ECR_HELPER_FILE} | grep ${ECR_HELPER_SHA256}; \
    chmod +x ${INSTALL_DIR}/${ECR_HELPER_FILE}

ARG TRIVY_VERSION=0.21.1
ARG TRIVY_URL=https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
ARG TRIVY_FILE=trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
ARG TRIVY_SHA256=4900136f41c713ce8d202e9aa055543a11e56bc280bc864719d4343dc2d3e696

RUN set -exo pipefail; curl -fsSL --retry 3 -o ${TRIVY_FILE} ${TRIVY_URL}; \
    sha256sum ${TRIVY_FILE} | grep ${TRIVY_SHA256}; \
    tar -xvzf ${TRIVY_FILE} -C ${INSTALL_DIR} trivy

ARG GITCHGLOG_VERSION=0.15.0
ARG GITCHGLOG_URL=https://github.com/git-chglog/git-chglog/releases/download/v${GITCHGLOG_VERSION}/git-chglog_${GITCHGLOG_VERSION}_linux_amd64.tar.gz
ARG GITCHGLOG_FILE=git-chglog_${GITCHGLOG_VERSION}_linux_amd64.tar.gz
ARG GITCHGLOG_SHA256=815ff0b78b3c3a0cc5e5e456d5f022a56d1f8e34d99165e4476e74be68646854

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


FROM alpine:3.15

ARG USERNAME=toolbox
ENV USER=${USERNAME} \
    HELM_HOME=/tmp/.helm \
    AWS_DEFAULT_REGION=eu-west-1

# Keep Ansible output colorized
ENV ANSIBLE_FORCE_COLOR=true \
    ANSIBLE_HOST_KEY_CHECKING=False

RUN apk --no-cache update && apk --no-cache upgrade && \
    apk --no-cache add ca-certificates git curl bash procps jq python3 python3-dev py-pip make openssh-client openssl \
    gnupg gcc musl-dev openssl-dev libffi-dev ansible && \
    setcap cap_net_raw+ep /bin/busybox

COPY requirements.txt /
RUN pip3 install --no-cache-dir --upgrade pip setuptools && \
    pip3 install --no-cache-dir -r /requirements.txt

RUN set -ex; curl -fsSL --retry 3 -o /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-git-crypt/master/sgerrand.rsa.pub && \
    curl -fsSL --retry 3 -O https://github.com/sgerrand/alpine-pkg-git-crypt/releases/download/0.6.0-r1/git-crypt-0.6.0-r1.apk && \
    apk add git-crypt-0.6.0-r1.apk && rm -f git-crypt-0.6.0-r1.apk && \
    ln -s /bin/git-crypt /usr/local/bin/git-crypt

# Add non-privileged user
RUN addgroup -g 992 ${USERNAME} && \
    adduser -D -u 995 -G ${USERNAME} ${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder --chown=${USERNAME} /root/.ansible .ansible

RUN mkdir -p /home/${USERNAME}/.docker
COPY --chown=${USERNAME}:${USERNAME} config.json /home/${USERNAME}/.docker/

# Other common binaries
COPY bin/* /usr/local/bin/
