# syntax=docker/dockerfile:1

FROM alpine:3.20 AS builder

RUN apk add --no-cache ca-certificates

ARG VERSION

RUN set -eux; apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
        x86_64)  arch='amd64';; \
        aarch64) arch='arm64';; \
        armhf)   arch='armv6';; \
        armv7)   arch='armv7';; \
        ppc64le) arch='ppc64le';; \
        s390x)   arch='s390x';; \
        *) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
    esac; \
    wget -O registry.tar.gz "https://github.com/distribution/distribution/releases/download/v${VERSION}/registry_${VERSION}_linux_${arch}.tar.gz"; \
    tar --extract --verbose --file registry.tar.gz --directory /bin/ registry; \
    rm registry.tar.gz; \
    registry --version


FROM alpine:3.20

ARG USER=registry
ARG GROUP=registry

RUN set -ex; apk --no-cache update && apk --no-cache upgrade && \
    apk add --no-cache ca-certificates apache2-utils && \
    addgroup -g 10001 ${GROUP} && \
    adduser -h /home/${USER} -u 10001 -G ${GROUP} -D ${USER}

COPY --from=builder --chown=${USER}:${GROUP} /bin/registry /bin/registry
COPY --chown=${USER}:${GROUP} config-example.yml /etc/docker/registry/config.yml
COPY --chown=${USER}:${GROUP} tmp/entrypoint.sh /entrypoint.sh

VOLUME ["/var/lib/registry"]
EXPOSE 5000

USER ${USER}

WORKDIR /var/lib/registry

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/etc/docker/registry/config.yml"]
