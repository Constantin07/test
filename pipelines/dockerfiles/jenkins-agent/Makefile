
REPOSITORY ?= constantin07/jenkins-agent

# Check for required binaries
EXECUTABLES = git docker
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT := $(shell git rev-parse --short HEAD)

VERSION=4.8

.PHONY: all login build tag push
all: build tag publish

login:
	@docker login -u "${DOCKERHUB_USERNAME}" -p "${DOCKERHUB_PASSWORD}"

build:
	docker build -t ${REPOSITORY}:latest .

tag:
	docker tag ${REPOSITORY}:latest ${REPOSITORY}:${VERSION}

push: login
	docker push ${REPOSITORY}:latest
	docker push ${REPOSITORY}:${VERSION}
