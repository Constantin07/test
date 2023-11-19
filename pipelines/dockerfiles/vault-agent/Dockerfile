# syntax=docker/dockerfile:1

FROM alpine:3.18

ARG VAULT_VERSION

RUN addgroup -g 10001 vault && \
    adduser -S -u 10001 -G vault vault

RUN set -eux; \
    apk --no-cache update && apk --no-cache upgrade && \
    apk add --no-cache ca-certificates libcap su-exec dumb-init tzdata && \
    apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
      armhf) ARCH='arm' ;; \
      aarch64) ARCH='arm64' ;; \
      x86_64) ARCH='amd64' ;; \
      x86) ARCH='386' ;; \
      *) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
    esac && \
    wget -q https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${ARCH}.zip && \
    unzip vault_${VAULT_VERSION}_linux_${ARCH}.zip && \
    mv ./vault /bin/vault && \
    rm -f vault_*.zip

RUN mkdir -p /vault/logs && \
    mkdir -p /vault/file && \
    mkdir -p /vault/config && \
    chown -R vault:vault /vault

VOLUME /vault/logs

VOLUME /vault/file

EXPOSE 8200

#checkov:skip=CKV_DOCKER_3: vault user in the container is already created
