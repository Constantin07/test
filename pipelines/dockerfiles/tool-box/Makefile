SHELL := /bin/bash

REGISTRY ?= centos7.internal:5000
DOCKER_REPOSITORY ?= constantin07/tool-box
IMAGE ?= tool-box

# Check for required binaries
EXECUTABLES = git podman trivy
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

default: build tag push clean

all: login build scan tag push publish

login:
	@echo "${DOCKERHUB_TOKEN}" | podman login -u "${DOCKERHUB_USERNAME}" --password-stdin docker.io

build:
	@cp -a ../../../ansible/requirements.yml .
	@cp -a ../../../bin .
	podman build --pull --format docker -t ${REGISTRY}/${IMAGE}:${TAG} .
	@rm -f requirements.yml
	@rm -rf bin

scan:
	@trivy image --exit-code 0 --no-progress --format json --output results.json ${REGISTRY}/${IMAGE}:${TAG}

tag:
	podman tag ${REGISTRY}/${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:latest
	podman tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REPOSITORY}:${TAG}
	podman tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REPOSITORY}:latest

push:
	podman push --tls-verify=false ${REGISTRY}/${IMAGE}:${TAG}
	podman push --tls-verify=false ${REGISTRY}/${IMAGE}:latest

# Publish to DockerHub
publish: login
	podman push ${DOCKER_REPOSITORY}:${TAG}
	podman push ${DOCKER_REPOSITORY}:latest

clean:
	podman rmi ${REGISTRY}/${IMAGE}:latest || true
	podman rmi ${REGISTRY}/${IMAGE}:${TAG} || true
