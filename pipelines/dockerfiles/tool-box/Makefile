SHELL := /bin/bash

REGISTRY ?= centos7.internal:5000
DOCKER_REGISTRY ?= constantin07/tool-box
IMAGE ?= tool-box

# Check for required binaries
EXECUTABLES = git docker
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


GIT_COMMIT := $(shell git rev-parse --short HEAD)

ifdef BUILD_NUMBER
  TAG="${BUILD_NUMBER}-${GIT_COMMIT}"
else
  TAG=${GIT_COMMIT}
endif

.DEFAULT_GOAL := default

.PHONY: default
default: build tag publish

.PHONY: all
all: build tag publish clean

.PHONY: login
login:
	docker login -u "${DOCKERHUB_USERNAME}" -p "${DOCKERHUB_PASSWORD}"

.PHONY: build
build:
	docker build -t ${REGISTRY}/${IMAGE}:${TAG} .

.PHONY: tag
tag:
	docker tag ${REGISTRY}/${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:latest
	docker tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REGISTRY}:${TAG}
	docker tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REGISTRY}:latest

.PHONY: push
push:
	docker push ${REGISTRY}/${IMAGE}:${TAG}
	docker push ${REGISTRY}/${IMAGE}:latest

# Publish to DockerHub
.PHONY: publish
publish: login
	docker push ${DOCKER_REGISTRY}:${TAG}
	docker push ${DOCKER_REGISTRY}:latest

.PHONY: clean
clean:
	docker rmi ${REGISTRY}/${IMAGE}:${TAG} || true
	docker rmi ${REGISTRY}/${IMAGE}:latest || true
