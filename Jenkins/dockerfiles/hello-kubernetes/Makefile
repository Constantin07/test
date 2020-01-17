SHELL := /bin/bash

REGISTRY ?= centos7.internal:5000
IMAGE ?= hello-kubernetes

GIT_COMMIT := $(shell git rev-parse --short HEAD)

ifdef BUILD_NUMBER
  TAG="${BUILD_NUMBER}-${GIT_COMMIT}"
else
  TAG=${GIT_COMMIT}
endif

.PHONY: all
all: |build tag publish

.PHONY: build
build:
	docker build -t ${REGISTRY}/${IMAGE}:${TAG} .

.PHONY: tag
tag:
	docker tag ${REGISTRY}/${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:latest

.PHONY: publish
publish:
	docker push ${REGISTRY}/${IMAGE}:${TAG}
	docker push ${REGISTRY}/${IMAGE}:latest

.PHONY: clean
clean:
	docker rmi ${REGISTRY}/${IMAGE}:${TAG} || true
	docker rmi ${REGISTRY}/${IMAGE}:latest || true
