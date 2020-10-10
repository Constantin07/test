FROM golang:1.13.1

ARG PROJ_ROOT=github.com/hashicorp/terraform
ARG GOOS
ARG GOARCH

# Use shallow clones for go get
RUN go get github.com/schollz/git
ENV PATH="${GOPATH}/bin:${PATH}"

RUN go get -v ${PROJ_ROOT}

WORKDIR ${GOPATH}/src/${PROJ_ROOT}

RUN make tools && \
    CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build -ldflags -s -o bin/terraform .
