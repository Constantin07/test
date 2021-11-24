# Build a minimal distribution container

FROM alpine:3.15

ARG DIR=tmp/amd64/

RUN set -ex; apk --no-cache update && apk --no-cache upgrade && \
    apk add --no-cache ca-certificates apache2-utils

COPY ${DIR}/registry /bin/registry
COPY config-example.yml /etc/docker/registry/config.yml

VOLUME ["/var/lib/registry"]
EXPOSE 5000

COPY ${DIR}/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/etc/docker/registry/config.yml"]
