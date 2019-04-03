# Build a minimal distribution container

FROM alpine:latest

RUN set -ex && \
    apk add --no-cache ca-certificates apache2-utils && \
    apk update && apk upgrade && \
    rm -rf /usr/share/man/* /tmp/* /var/cache/apk/*

COPY ./registry /bin/registry
COPY ./config.yml /etc/docker/registry/config.yml

VOLUME ["/var/lib/registry"]
EXPOSE 5000

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/etc/docker/registry/config.yml"]
