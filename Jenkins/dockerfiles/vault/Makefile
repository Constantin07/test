SHELL := /bin/bash

REGISTRY ?= centos7.internal:5000
IMAGE ?= vault

GIT_COMMIT := $(shell git rev-parse --short HEAD)

ifndef VAULT_VERSION
$(error VAULT_VERSION environment variable must be defined!)
endif

.PHONY: all build tag publish clean
all: build tag publish

build:
	docker build --build-arg VAULT_VERSION=${VAULT_VERSION} -t ${REGISTRY}/${IMAGE}:${VAULT_VERSION} .

tag:
	docker tag ${REGISTRY}/${IMAGE}:${VAULT_VERSION} ${REGISTRY}/${IMAGE}:latest

publish:
	docker push ${REGISTRY}/${IMAGE}:${VAULT_VERSION}
	docker push ${REGISTRY}/${IMAGE}:latest

clean:
	docker rmi ${REGISTRY}/${IMAGE}:${VAULT_VERSION} || true
	docker rmi ${REGISTRY}/${IMAGE}:latest || true
