FROM alpine:3.13.1 AS builder

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache curl unzip && \
    curl -fsSL --retry 3 https://releases.hashicorp.com/vault/1.6.2/vault_1.6.2_linux_amd64.zip -o vault.zip && \
    unzip vault.zip && chmod +x vault


FROM node:14.15.4-alpine3.12

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache jq

RUN mkdir -p /usr/src/app
COPY . /usr/src/app
RUN chown -R node:node /usr/src/app

COPY --from=builder /vault /usr/local/bin/

WORKDIR /usr/src/app

USER node
RUN npm install

CMD [ "npm", "start" ]
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
