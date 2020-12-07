SHELL := /bin/bash

REGISTRY ?= centos7.internal:5000
IMAGE ?= vault

# Check for required binaries
EXECUTABLES = git docker
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT := $(shell git rev-parse --short HEAD)

ifndef VAULT_VERSION
$(error VAULT_VERSION environment variable must be defined!)
endif

.PHONY: all login build tag publish clean
all: build tag publish

login:
	docker login -u "${DOCKERHUB_USERNAME}" -p "${DOCKERHUB_PASSWORD}"

build:
	docker build --build-arg VAULT_VERSION=${VAULT_VERSION} -t ${REGISTRY}/${IMAGE}:${VAULT_VERSION} .

tag:
	docker tag ${REGISTRY}/${IMAGE}:${VAULT_VERSION} ${REGISTRY}/${IMAGE}:latest

publish:
	docker push ${REGISTRY}/${IMAGE}:${VAULT_VERSION}
	docker push ${REGISTRY}/${IMAGE}:latest

clean:
	docker rmi ${REGISTRY}/${IMAGE}:${VAULT_VERSION} || true
	docker rmi ${REGISTRY}/${IMAGE}:latest || true
