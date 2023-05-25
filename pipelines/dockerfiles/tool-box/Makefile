SHELL := /bin/bash

REGISTRY ?= registry.internal:5000
DOCKER_REPOSITORY ?= constantin07/tool-box
IMAGE ?= tool-box

# Check for required binaries
EXECUTABLES = git trivy
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT := $(shell git rev-parse --short HEAD)

ifdef BUILD_NUMBER
  TAG=${BUILD_NUMBER}-${GIT_COMMIT}
else
  TAG=${GIT_COMMIT}
endif

.PHONY: default all login build scan tag push publish

.DEFAULT_GOAL := default

default: build tag test push clean

all: login build scan tag push publish

login:
	@echo "${DOCKERHUB_TOKEN}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin

build:
	@cp -a ../../../ansible/requirements.yml .
	@cp -a ../../../bin .
	@./add_ca_certs.sh
	docker build -t ${REGISTRY}/${IMAGE}:${TAG} .
	@rm -f *_ca.crt
	@rm -f requirements.yml
	@rm -rf bin results.json

scan:
	@trivy image --exit-code 0 --no-progress --format json --output results.json ${REGISTRY}/${IMAGE}:${TAG}

tag:
	docker tag ${REGISTRY}/${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:latest
	docker tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REPOSITORY}:${TAG}
	docker tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REPOSITORY}:latest

push:
	docker push ${REGISTRY}/${IMAGE}:${TAG}
	docker push ${REGISTRY}/${IMAGE}:latest

# Publish to DockerHub
publish: login
	docker push ${DOCKER_REPOSITORY}:${TAG}
	docker push ${DOCKER_REPOSITORY}:latest

clean:
	@rm -f *_ca.crt requirements.yml
	@rm -rf bin results.json

test:
	@echo "Testing image"
	@docker run --rm -it ${REGISTRY}/${IMAGE}:${TAG} python3 -V
	@docker run --rm -it ${REGISTRY}/${IMAGE}:${TAG} ansible --version
