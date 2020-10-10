
IMAGE_NAME ?= terraform:latest
INSTALL_DIR ?= /usr/local/bin

GOARCH ?= amd64
GOOS ?= linux

.PHONY: all build install clean

all: build clean

build:
	docker build --build-arg GOOS=${GOOS} --build-arg GOARCH=${GOARCH} -t ${IMAGE_NAME} .

install:
	docker run --rm -v ${INSTALL_DIR}:${INSTALL_DIR} --entrypoint cp ${IMAGE_NAME} bin/terraform ${INSTALL_DIR}/terraform
	chmod +x ${INSTALL_DIR}/terraform

clean:
	docker rmi ${IMAGE_NAME} || true
