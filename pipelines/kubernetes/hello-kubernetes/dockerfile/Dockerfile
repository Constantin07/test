FROM alpine:3.13 AS builder

ARG VAULT_VERSION=1.7.0

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache curl unzip && \
    curl -fsSL --retry 3 https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o vault.zip && \
    unzip vault.zip && chmod +x vault


FROM node:15.12.0-alpine3.13

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache jq ca-certificates

COPY --chown=node:node . /home/node/
COPY --from=builder /vault /usr/local/bin/

RUN update-ca-certificates

USER node
WORKDIR /home/node

RUN npm install

CMD [ "npm", "start" ]
ENTRYPOINT ["/home/node/entrypoint.sh"]
