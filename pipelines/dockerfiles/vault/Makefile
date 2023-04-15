SHELL := /bin/bash

REGISTRY ?= centos7.internal:5000
IMAGE ?= vault

# Check for required binaries
EXECUTABLES = git docker
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT := $(shell git rev-parse --short HEAD)

VAULT_VERSION = 1.13.1

.PHONY: login build scan tag publish clean
default: build tag publish

login:
	@echo "${DOCKERHUB_TOKEN}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin docker.io

build:
	docker build --compress --build-arg VAULT_VERSION=${VAULT_VERSION} -t ${REGISTRY}/${IMAGE}:${VAULT_VERSION} .

scan:
	trivy image --vuln-type="os,library" --exit-code 0 --no-progress --format json --output results.json ${REGISTRY}/${IMAGE}:${VAULT_VERSION}

tag:
	docker tag ${REGISTRY}/${IMAGE}:${VAULT_VERSION} ${REGISTRY}/${IMAGE}:latest

publish:
	docker push ${REGISTRY}/${IMAGE}:${VAULT_VERSION}
	docker push ${REGISTRY}/${IMAGE}:latest

clean:
	docker rmi ${REGISTRY}/${IMAGE}:${VAULT_VERSION} || true
	docker rmi ${REGISTRY}/${IMAGE}:latest || true
