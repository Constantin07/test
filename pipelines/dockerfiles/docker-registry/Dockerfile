FROM alpine:3.18 AS builder

RUN apk add --no-cache ca-certificates

ARG VERSION

RUN set -eux; apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
	x86_64)  arch='amd64';   sha256='f1a376964912a5fd7d588107ebe5185da77803244e15476d483c945959347ee2' ;; \
        aarch64) arch='arm64';   sha256='4c588c8e62c9a84f1eecfba4c842fe363b91be87fd42e3b5dac45148a2f46c52' ;; \
        armhf)   arch='armv6';   sha256='d711b3b6e77f3acc7c89fad9310413ef145751ac702627dc1fa89991bf3b6104' ;; \
        armv7)   arch='armv7';   sha256='d2f2180c1a847056f9c5dcfd1d6fda4c6086d126204541e0ed047c04f30a0f91' ;; \
        ppc64le) arch='ppc64le'; sha256='ca77cdfb7b1415869558c118b5e783bb9d695a74d8426a0bd8d8a39beb23fb85' ;; \
        s390x)   arch='s390x';   sha256='3e505af15c562870869441d5d1f79988c3c666b9a4370894ecf2f064860b48ba' ;; \
        *) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
    esac; \
    wget -O registry.tar.gz "https://github.com/distribution/distribution/releases/download/v${VERSION}/registry_${VERSION}_linux_${arch}.tar.gz"; \
    echo "$sha256 *registry.tar.gz" | sha256sum -c -; \
    tar --extract --verbose --file registry.tar.gz --directory /bin/ registry; \
    rm registry.tar.gz; \
    registry --version


FROM alpine:3.18

ARG USER=registry
ARG GROUP=registry

RUN set -ex; apk --no-cache update && apk --no-cache upgrade && \
    apk add --no-cache ca-certificates apache2-utils && \
    addgroup -g 10001 ${GROUP} && \
    adduser -h /home/${USER} -u 10001 -G ${GROUP} -D ${USER}

COPY --from=builder --chown=${USER}:${GROUP} /bin/registry /bin/registry
COPY --chown=${USER}:${GROUP} config-example.yml /etc/docker/registry/config.yml
COPY --chown=${USER}:${GROUP} tmp/docker-entrypoint.sh /entrypoint.sh

VOLUME ["/var/lib/registry"]
EXPOSE 5000

USER ${USER}

WORKDIR /var/lib/registry

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/etc/docker/registry/config.yml"]
