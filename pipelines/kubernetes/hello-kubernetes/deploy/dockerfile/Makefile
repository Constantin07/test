SHELL := /bin/bash

DOCKER_REGISTRY ?= centos7.internal:5000
IMAGE ?= hello-kubernetes

# Check for required binaries
EXECUTABLES = git docker
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT_SHORT ?= $(shell git rev-parse --short HEAD)

ifdef BUILD_NUMBER
  TAG=${BUILD_NUMBER}-${GIT_COMMIT_SHORT}
else
  TAG=${GIT_COMMIT_SHORT}
endif

.PHONY: all login build scan tag push clean
all: |login build tag scan push

login:
	docker login -u "${DOCKERHUB_USERNAME}" -p "${DOCKERHUB_TOKEN}"

build:
	docker build -t ${DOCKER_REGISTRY}/${IMAGE}:${TAG} .

scan:
	trivy image --exit-code 0 --no-progress --format json --output results.json ${DOCKER_REGISTRY}/${IMAGE}:${TAG}
	trivy image --reset

tag:
	docker tag ${DOCKER_REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REGISTRY}/${IMAGE}:latest

push:
	docker push ${DOCKER_REGISTRY}/${IMAGE}:${TAG}
	docker push ${DOCKER_REGISTRY}/${IMAGE}:latest

clean:
	docker rmi ${DOCKER_REGISTRY}/${IMAGE}:${TAG} || true
	docker rmi ${DOCKER_REGISTRY}/${IMAGE}:latest || true
