REGISTRY ?= constantin07
IMAGE_NAME ?= docker-registry
SERVICE_PORT ?= 5000
DOCKER_REGISTRY = https://github.com/docker/distribution-library-image.git
TMP_DIR = tmp

# Check for required binaries
EXECUTABLES = git docker
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT := $(shell git rev-parse --short HEAD)

ifndef REMOTE_TAG
  TAG=$(GIT_COMMIT)
else
  TAG=$(REMOTE_TAG)
endif

.PHONY: tmp build login tag push clean deploy

tmp:
	git clone --depth 1 --single-branch -b master ${DOCKER_REGISTRY} ${TMP_DIR}

login:
	@echo "${DOCKERHUB_TOKEN}" | docker login --username "${DOCKERHUB_USERNAME}" --password-stdin

build: tmp login
	docker build --pull --tag ${REGISTRY}/${IMAGE_NAME}:${TAG} .

tag:
	docker tag ${REGISTRY}/${IMAGE_NAME}:${TAG} ${REGISTRY}/${IMAGE_NAME}:latest

push: login
	docker push ${REGISTRY}/${IMAGE_NAME}:${TAG}
	docker push ${REGISTRY}/${IMAGE_NAME}:latest

clean:
	docker rmi ${REGISTRY}/${IMAGE_NAME}:${TAG} || true
	docker rmi ${REGISTRY}/${IMAGE_NAME}:latest || true
	@rm -rf ${TMP_DIR}

deploy:
	docker stop ${IMAGE_NAME} || true
	docker rm ${IMAGE_NAME} || true
	docker run -d --name ${IMAGE_NAME} \
	-p ${SERVICE_PORT}:${SERVICE_PORT} \
	-v /var/lib/registry:/var/lib/registry \
	--memory 256m --cpus "0.5" \
	--restart unless-stopped \
	${REGISTRY}/${IMAGE_NAME}:${TAG}

test:
	@./test.sh
