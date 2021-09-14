
REPOSITORY ?= constantin07/jenkins-agent

# Check for required binaries
EXECUTABLES = git img
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT := $(shell git rev-parse --short HEAD)

VERSION=4.10

.PHONY: all login build scan tag push clean
all: build tag push

login:
	@echo "${DOCKERHUB_TOKEN}" | img login --username "${DOCKERHUB_USERNAME}" --password-stdin

build: login
	img build -t ${REPOSITORY}:${VERSION} .

scan:
	img unpack ${REPOSITORY}:${VERSION}
	trivy fs --exit-code 0 --no-progress --format json --output results.json rootfs/
	rm -rf rootfs/

tag:
	img tag ${REPOSITORY}:${VERSION} ${REPOSITORY}:latest

push: login
	img push ${REPOSITORY}:${VERSION}
	img push ${REPOSITORY}:latest

clean:
	img rm ${REPOSITORY}:latest
	img rm ${REPOSITORY}:${VERSION}
