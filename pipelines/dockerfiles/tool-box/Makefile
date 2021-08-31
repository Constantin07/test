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

all: build tag push publish

login:
#	@echo "${DOCKERHUB_TOKEN}" | img login -u "${DOCKERHUB_USERNAME}" --password-stdin
	@echo "${DOCKERHUB_TOKEN}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin

build:
	@cp -a ../../../ansible/requirements.yml .
	@cp -a ../../../bin .
#	img build -t ${REGISTRY}/${IMAGE}:${TAG} .
	docker build -t ${REGISTRY}/${IMAGE}:${TAG} .
	@rm -f requirements.yml
	@rm -rf bin

scan:
	trivy image --exit-code 0 --no-progress --format json --output results.json ${REGISTRY}/${IMAGE}:${TAG}

tag:
#	img tag ${REGISTRY}/${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:latest
#	img tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REPOSITORY}:${TAG}
#	img tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REPOSITORY}:latest
	docker tag ${REGISTRY}/${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:latest
	docker tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REPOSITORY}:${TAG}
	docker tag ${REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REPOSITORY}:latest

push:
#	img push --insecure-registry ${REGISTRY}/${IMAGE}:${TAG}
#	img push --insecure-registry ${REGISTRY}/${IMAGE}:latest
	docker push ${REGISTRY}/${IMAGE}:${TAG}
	docker push ${REGISTRY}/${IMAGE}:latest

# Publish to DockerHub
publish: login
#	img push ${DOCKER_REPOSITORY}:${TAG}
#	img push ${DOCKER_REPOSITORY}:latest
	docker push ${DOCKER_REPOSITORY}:${TAG}
	docker push ${DOCKER_REPOSITORY}:latest
