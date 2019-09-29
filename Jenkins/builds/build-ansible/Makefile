SHELL := /bin/bash

IMAGE_NAME = ansible:latest
BUILD_DIR = /ansible/rpm-build
HOST_DIR = $(shell pwd)

.PHONY: all build copy install clean

all: build copy clean

build:
	docker build -t ${IMAGE_NAME} .

copy:
	$(eval export FILENAME=$(shell docker run --rm ${IMAGE_NAME} bash -c "cd ${BUILD_DIR}; ls -1 ansible-*.noarch.rpm"))
	docker run --rm -v ${HOST_DIR}:/tmp -w ${BUILD_DIR} --entrypoint cp ${IMAGE_NAME} ${FILENAME} /tmp

install:
	sudo yum -y remove ansible
	sudo yum -y install ${FILENAME}

clean:
	docker rmi ${IMAGE_NAME} || true
