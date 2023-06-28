SHELL := /bin/bash

REPOSITORY := constantin07/golang-terratest

# Check for required binaries
EXECUTABLES = git docker
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

TAG = 1.0.0

.PHONY: login build scan publish clean
default: login build publish

login:
	@echo "${DOCKERHUB_TOKEN}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin docker.io

build:
	docker build --provenance=true -t ${REPOSITORY}:${TAG} .

scan:
	trivy image --vuln-type="os,library" --exit-code 0 --no-progress --format json --output results.json ${REPOSITORY}:${TAG}

publish:
	docker push ${REPOSITORY}:${TAG}

clean:
	docker rmi ${REPOSITORY}:${TAG} || true
