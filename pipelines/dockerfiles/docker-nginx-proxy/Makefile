REPOSITORY ?= constantin07/docker-nginx-proxy

# Check for required binaries
EXECUTABLES = podman trivy
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

VERSION=0.0.1

.PHONY: all login build scan tag push clean
all: build tag push

login:
	@echo "${DOCKERHUB_TOKEN}" | podman login --username "${DOCKERHUB_USERNAME}" --password-stdin docker.io

build: login
	podman build --pull --format docker -t ${REPOSITORY}:${VERSION} .

scan:
	@trivy image --exit-code 0 --no-progress --format json --output results.json ${REPOSITORY}:${VERSION}

tag:
	podman tag ${REPOSITORY}:${VERSION} ${REPOSITORY}:latest

push: login
	podman push ${REPOSITORY}:${VERSION}
	podman push ${REPOSITORY}:latest

clean:
	podman rmi ${REPOSITORY}:latest || true
	podman rmi ${REPOSITORY}:${VERSION} || true
