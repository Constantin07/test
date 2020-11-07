# Build a minimal distribution container

FROM alpine:3.12.1

ARG DIR=tmp/amd64/

RUN set -ex && \
    apk add --no-cache ca-certificates apache2-utils && \
    apk update && apk upgrade && \
    rm -rf /usr/share/man/* /tmp/* /var/cache/apk/*

COPY ${DIR}/registry /bin/registry
COPY config-example.yml /etc/docker/registry/config.yml

VOLUME ["/var/lib/registry"]
EXPOSE 5000

COPY ${DIR}/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/etc/docker/registry/config.yml"]
