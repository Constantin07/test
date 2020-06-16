SHELL := /bin/bash

DOCKER_REGISTRY ?= centos7.internal:5000
IMAGE ?= hello-kubernetes

GIT_COMMIT ?= $(shell git rev-parse HEAD)

ifdef BUILD_NUMBER
  TAG=${BUILD_NUMBER}-${GIT_COMMIT}
else
  TAG=${GIT_COMMIT}
endif

.PHONY: all
all: |build tag publish

.PHONY: build
build:
	docker build -t ${DOCKER_REGISTRY}/${IMAGE}:${TAG} .

.PHONY: tag
tag:
	docker tag ${DOCKER_REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REGISTRY}/${IMAGE}:latest

.PHONY: publish
publish:
	docker push ${DOCKER_REGISTRY}/${IMAGE}:${TAG}
	docker push ${DOCKER_REGISTRY}/${IMAGE}:latest

.PHONY: clean
clean:
	docker rmi ${DOCKER_REGISTRY}/${IMAGE}:${TAG} || true
	docker rmi ${DOCKER_REGISTRY}/${IMAGE}:latest || true
