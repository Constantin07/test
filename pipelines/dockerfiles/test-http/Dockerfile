# syntax=docker/dockerfile:1

FROM golang:1.22-alpine3.18 as BUILDER

WORKDIR /app

COPY . .

RUN go mod download && \
    go test

RUN CGO_ENABLED=0 GOOS=linux go build -o /server


FROM alpine:3.22

RUN apk --no-cache update && apk --no-cache upgrade && \
    addgroup -g 10001 app && \
    adduser -h /home/app -u 10001 -G app -D app && \
    chown -R 10001:10001 /home/app

COPY --from=BUILDER --chown=app:app /server /home/app/server

USER app

WORKDIR /home/app

ENTRYPOINT ["/home/app/server"]
