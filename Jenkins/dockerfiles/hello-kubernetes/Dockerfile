FROM node:12.16.1-alpine3.11

RUN apk update && \
    apk add --no-cache jq vault && \
    chmod +x /usr/sbin/vault

RUN mkdir -p /usr/src/app
COPY . /usr/src/app
RUN chown -R node:node /usr/src/app

WORKDIR /usr/src/app

USER node
RUN npm install

CMD [ "npm", "start" ]
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
