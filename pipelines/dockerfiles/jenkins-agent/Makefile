
REPOSITORY ?= constantin07/jenkins-agent

# Check for required binaries
EXECUTABLES = git img
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT := $(shell git rev-parse --short HEAD)

VERSION=4.8

.PHONY: all login build tag push clean
all: build tag push

login:
	@echo "${DOCKERHUB_TOKEN}" | img login --username "${DOCKERHUB_USERNAME}" --password-stdin

build:
	img build -t ${REPOSITORY}:latest .

tag:
	img tag ${REPOSITORY}:latest ${REPOSITORY}:${VERSION}

push: login
	img push ${REPOSITORY}:latest
	img push ${REPOSITORY}:${VERSION}

clean:
	img rm ${REPOSITORY}:latest
	img rm ${REPOSITORY}:${VERSION}
