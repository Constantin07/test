SHELL := /bin/bash

REGISTRY ?= centos7.internal:5000
DOCKER_REPOSITORY ?= constantin07/tool-box
IMAGE ?= tool-box

# Check for required binaries
EXECUTABLES = git docker
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

default: build tag push

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
	$(eval TMP_DIR := $(shell mktemp -d))
	@podman image save --quiet --format docker-archive ${REGISTRY}/${IMAGE}:${TAG} | tar -x --wildcards -C ${TMP_DIR} --warning=no-timestamp
	@find ${TMP_DIR} -type f -name '*.tar' -print0 | xargs -r -0 --max-args=1 tar -C ${TMP_DIR} --warning=no-timestamp -xf
	@trivy fs --exit-code 0 --no-progress --format json --output results.json ${TMP_DIR}
	@rm -rf ${TMP_DIR}

tag:
	podman tag ${REGISTRY}/${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:latest
	podman tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REPOSITORY}:${TAG}
	podman tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REPOSITORY}:latest

push:
	podman push ${REGISTRY}/${IMAGE}:${TAG}
	podman push ${REGISTRY}/${IMAGE}:latest

# Publish to DockerHub
publish: login
	podman push ${DOCKER_REPOSITORY}:${TAG}
	podman push ${DOCKER_REPOSITORY}:latest

clean:
	podman rmi ${REGISTRY}/${IMAGE}:latest || true
	podman rmi ${REGISTRY}/${IMAGE}:${TAG} || true
