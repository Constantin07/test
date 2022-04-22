REPOSITORY ?= constantin07/consul-template

# Check for required binaries
EXECUTABLES = docker trivy
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

VERSION=0.29.0

.PHONY: all login build scan tag push clean
all: build tag push

.ONESHELL:

login:
	@echo "${DOCKERHUB_TOKEN}" | docker login --username "${DOCKERHUB_USERNAME}" --password-stdin

build: login
	docker build --pull -t ${REPOSITORY}:${VERSION} .

scan:
	@trivy image --exit-code 0 --no-progress --format json --output results.json ${REPOSITORY}:${VERSION}

tag:
	docker tag ${REPOSITORY}:${VERSION} ${REPOSITORY}:latest

push: login
	docker push ${REPOSITORY}:${VERSION}
	docker push ${REPOSITORY}:latest

clean:
	docker rmi ${REPOSITORY}:latest || true
	docker rmi ${REPOSITORY}:${VERSION} || true
