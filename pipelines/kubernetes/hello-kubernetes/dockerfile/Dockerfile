FROM alpine:3.13 AS builder

ARG VAULT_VERSION=1.6.3

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache curl unzip && \
    curl -fsSL --retry 3 https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o vault.zip && \
    unzip vault.zip && chmod +x vault


FROM node:14.15.4-alpine3.12

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache jq

COPY --chown=node:node . /home/node/
COPY --from=builder /vault /usr/local/bin/

USER node
WORKDIR /home/node

RUN npm install

CMD [ "npm", "start" ]
ENTRYPOINT ["/home/node/entrypoint.sh"]
