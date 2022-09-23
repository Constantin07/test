FROM alpine:3.16 AS builder

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache curl unzip

ARG INSTALL_DIR=/usr/local/bin
WORKDIR ${INSTALL_DIR}

ARG VERSION
RUN curl -fsSL --retry 3 https://releases.hashicorp.com/consul-template/${VERSION}/consul-template_${VERSION}_linux_amd64.zip -o consul-template.zip && \
    unzip consul-template.zip && chmod +x consul-template && \
    rm -f consul-template.zip


FROM alpine:3.16

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache ca-certificates bash curl jq && \
    update-ca-certificates

ARG USER=consul
ARG GROUP=consul
RUN addgroup -g 1000 ${GROUP} && \
    adduser -h /home/${USER} -u 1000 -G ${GROUP} -D ${USER}

COPY --from=builder --chown=${USER}:${GROUP} /usr/local/bin/ /usr/local/bin/
COPY --chown=${USER}:${GROUP} get_token.sh /home/consul/

USER consul
WORKDIR /home/consul
