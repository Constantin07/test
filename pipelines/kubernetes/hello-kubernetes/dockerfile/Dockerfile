FROM alpine:3.12.1 AS builder

# Use HTTPS endpoint for the apk repositories
# https://github.com/gliderlabs/docker-alpine/issues/184
RUN set -eux; sed -i 's!http://dl-cdn.alpinelinux.org/!https://alpine.global.ssl.fastly.net/!g' /etc/apk/repositories && \
    apk update && apk add --no-cache curl unzip && \
    curl -fsSL --retry 3 https://releases.hashicorp.com/vault/1.6.0/vault_1.6.0_linux_amd64.zip -o vault.zip && \
    unzip vault.zip && chmod +x vault


FROM node:12.20.0-alpine3.12

# Use HTTPS endpoint for the apk repositories
# https://github.com/gliderlabs/docker-alpine/issues/184
RUN set -eux; sed -i 's!http://dl-cdn.alpinelinux.org/!https://alpine.global.ssl.fastly.net/!g' /etc/apk/repositories && \
    apk update && apk upgrade && apk add --no-cache jq

RUN mkdir -p /usr/src/app
COPY . /usr/src/app
RUN chown -R node:node /usr/src/app

COPY --from=builder /vault /usr/local/bin/

WORKDIR /usr/src/app

USER node
RUN npm install

CMD [ "npm", "start" ]
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
