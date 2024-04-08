# syntax=docker/dockerfile:1

FROM golang:1.22.2-alpine3.18

ARG USER=test
ENV HOME /home/$USER

RUN apk --no-cache update && apk --no-cache upgrade && \
    wget -q -P /usr/local/bin https://storage.googleapis.com/kubernetes-release/release/v1.29.2/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

RUN addgroup -g 10001 $USER && \
    adduser -D -u 10001 -h /home/$USER -G $USER $USER

USER $USER
WORKDIR $HOME
