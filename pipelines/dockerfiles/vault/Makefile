SHELL := /bin/bash

REPOSITORY := constantin07/vault

# Check for required binaries
EXECUTABLES = git docker
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT := $(shell git rev-parse --short HEAD)

VAULT_VERSION = 1.13.2

.PHONY: login build scan tag publish clean
default: build tag publish

login:
	@echo "${DOCKERHUB_TOKEN}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin docker.io

build:
	docker build --compress --build-arg VAULT_VERSION=${VAULT_VERSION} -t ${REPOSITORY}:${VAULT_VERSION} .

scan:
	trivy image --vuln-type="os,library" --exit-code 0 --no-progress --format json --output results.json ${REPOSITORY}:${VAULT_VERSION}

tag:
	docker tag ${REPOSITORY}:${VAULT_VERSION} ${REPOSITORY}:latest

publish:
	docker push ${REPOSITORY}:${VAULT_VERSION}
	docker push ${REPOSITORY}:latest

clean:
	docker rmi ${REPOSITORY}:${VAULT_VERSION} || true
	docker rmi ${REPOSITORY}:latest || true
