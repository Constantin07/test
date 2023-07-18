# syntax=docker/dockerfile:1

FROM golang:1.20-alpine3.18

RUN wget -q -P /usr/local/bin https://storage.googleapis.com/kubernetes-release/release/v1.27.3/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl
