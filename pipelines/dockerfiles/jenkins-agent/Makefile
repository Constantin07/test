REPOSITORY ?= constantin07/jenkins-agent

# Check for required binaries
EXECUTABLES = git podman tar
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT := $(shell git rev-parse --short HEAD)

VERSION=4.11.2

.PHONY: all login build scan tag push clean
all: build tag push

login:
	@echo "${DOCKERHUB_TOKEN}" | podman login --username "${DOCKERHUB_USERNAME}" --password-stdin docker.io

build: login
	podman build --pull --format docker -t ${REPOSITORY}:${VERSION} .

scan:
	$(eval TMP_DIR := $(shell mktemp -d))
	@podman image save --quiet --format docker-archive ${REPOSITORY}:${VERSION} | tar -x --wildcards -C ${TMP_DIR} --warning=no-timestamp
	@find ${TMP_DIR} -type f -name '*.tar' -print0 | xargs -r -0 --max-args=1 tar -C ${TMP_DIR} --warning=no-timestamp -xf
	@trivy fs --exit-code 0 --no-progress --format json --output results.json ${TMP_DIR}
	@rm -rf ${TMP_DIR}

tag:
	podman tag ${REPOSITORY}:${VERSION} ${REPOSITORY}:latest

push: login
	podman push ${REPOSITORY}:${VERSION}
	podman push ${REPOSITORY}:latest

clean:
	podman rmi ${REPOSITORY}:latest || true
	podman rmi ${REPOSITORY}:${VERSION} || true
