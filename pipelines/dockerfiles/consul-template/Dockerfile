FROM alpine:3.16 AS builder

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache curl unzip

ARG INSTALL_DIR=/usr/local/bin
WORKDIR ${INSTALL_DIR}

ARG VERSION
RUN curl -fsSL --retry 3 https://releases.hashicorp.com/consul-template/${VERSION}/consul-template_${VERSION}_linux_amd64.zip -o consul-template.zip && \
    unzip consul-template.zip && chmod +x consul-template


FROM alpine:3.16

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache ca-certificates bash curl jq && \
    update-ca-certificates

COPY --from=builder /usr/local/bin/ /usr/local/bin/

ARG GROUP=consul
RUN addgroup -g 1000 1000 && \
    adduser -h /home/consul -u 1000 -G 1000 -D consul

COPY get_token.sh /home/consul/

USER consul
WORKDIR /home/consul
