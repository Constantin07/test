FROM alpine:3.9.4 AS BUILDER

ARG INSTALL_DIR="/usr/local/bin"

ARG TERRAFORM_VERSION=0.11.14
ARG TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG TERRAFORM_FILE="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG TERRAFORM_SHA256="9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd"

RUN apk --no-cache add curl unzip

RUN set -ex; curl -sS -L -o ${TERRAFORM_FILE} ${TERRAFORM_URL}; \
    sha256sum ${TERRAFORM_FILE} | grep ${TERRAFORM_SHA256}; \
    unzip -d ${INSTALL_DIR} ${TERRAFORM_FILE}; \
    chmod +x ${INSTALL_DIR}/terraform


FROM alpine:3.9.4

RUN apk --no-cache add ca-certificates

COPY --from=BUILDER /usr/local/bin /usr/local/bin
