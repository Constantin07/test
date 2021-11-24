FROM alpine:3.15 AS builder

ARG VAULT_VERSION=1.8.5

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache curl unzip && \
    curl -fsSL --retry 3 https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o vault.zip && \
    unzip vault.zip && chmod +x vault


FROM node:17-alpine3.14

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache jq ca-certificates && \
    update-ca-certificates

COPY --chown=node:node . /home/node/
COPY --from=builder /vault /usr/local/bin/

USER node
WORKDIR /home/node

RUN npm install

CMD [ "npm", "start" ]
ENTRYPOINT ["/home/node/entrypoint.sh"]
