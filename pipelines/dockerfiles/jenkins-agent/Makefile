REPOSITORY ?= constantin07/jenkins-agent

# Check for required binaries
EXECUTABLES = git docker trivy
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT := $(shell git rev-parse --short HEAD)

VERSION=3077.vd69cf116da_6f

.PHONY: all login build scan tag push clean
all: build tag push

login:
	@echo "${DOCKERHUB_TOKEN}" | docker login --username "${DOCKERHUB_USERNAME}" --password-stdin

build: login
	docker build --build-arg VERSION=${VERSION} --build-arg VAULT_ADDR=${VAULT_ADDR} -t ${REPOSITORY}:${VERSION} .

scan:
	@trivy image --exit-code 0 --no-progress --format json --output results.json ${REPOSITORY}:${VERSION}

tag:
	docker tag ${REPOSITORY}:${VERSION} ${REPOSITORY}:latest

push: login
	docker push ${REPOSITORY}:${VERSION}
	docker push ${REPOSITORY}:latest

clean:
	docker rmi ${REPOSITORY}:latest || true
	docker rmi ${REPOSITORY}:${VERSION} || true
