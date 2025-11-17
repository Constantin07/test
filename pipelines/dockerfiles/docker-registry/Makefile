REGISTRY ?= constantin07
IMAGE_NAME ?= docker-registry
SERVICE_PORT ?= 5000
DOCKER_REGISTRY = https://github.com/docker/distribution-library-image.git
TMP_DIR = tmp
# See https://github.com/distribution/distribution/releases
VERSION = 3.0.0

# Check for required binaries
EXECUTABLES = git docker
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT := $(shell git rev-parse --short HEAD)

TAG=$(VERSION)

.PHONY: version tmp login build scan tag push clean deploy
all: build tag push clean

version:
	@echo ${VERSION}

tmp:
	@rm -rf ${TMP_DIR}
	git clone --depth 1 --single-branch -b master ${DOCKER_REGISTRY} ${TMP_DIR}

login:
	@echo "${DOCKERHUB_TOKEN}" | docker login --username "${DOCKERHUB_USERNAME}" --password-stdin

build: tmp login
	docker build --build-arg VERSION=${VERSION} --tag ${REGISTRY}/${IMAGE_NAME}:${TAG} .

scan:
	trivy image --exit-code 0 --no-progress --format json --output results.json ${REGISTRY}/${IMAGE_NAME}:${TAG}

tag:
	docker tag ${REGISTRY}/${IMAGE_NAME}:${TAG} ${REGISTRY}/${IMAGE_NAME}:latest

push: login
	docker push ${REGISTRY}/${IMAGE_NAME}:${TAG}
	docker push ${REGISTRY}/${IMAGE_NAME}:latest

clean:
	docker rmi ${REGISTRY}/${IMAGE_NAME}:${TAG} || true
	docker rmi ${REGISTRY}/${IMAGE_NAME}:latest || true
	@rm -rf ${TMP_DIR}
