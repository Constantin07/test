FROM golang:1.12.7

ARG PROJ_ROOT=github.com/hashicorp/terraform
ARG GOOS
ARG GOARCH

RUN go get ${PROJ_ROOT}

WORKDIR ${GOPATH}/src/${PROJ_ROOT}

RUN make tools && \
    CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build -ldflags -s -o bin/terraform .
