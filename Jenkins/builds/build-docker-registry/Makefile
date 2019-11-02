
REGISTRY ?= centos7.internal:5000
IMAGE_NAME ?= docker-registry
SERVICE_PORT ?= 5000

GIT_COMMIT := $(shell git rev-parse --short HEAD)

ifndef REMOTE_TAG
  TAG=$(GIT_COMMIT)
else
  TAG=$(REMOTE_TAG)
endif

.PHONY: build tag push clean deploy

build:
	docker build --pull --tag ${REGISTRY}/${IMAGE_NAME}:${TAG} .

tag:
	docker tag ${REGISTRY}/${IMAGE_NAME}:${TAG} ${REGISTRY}/${IMAGE_NAME}:latest

push:
	docker push ${REGISTRY}/${IMAGE_NAME}:${TAG}
	docker push ${REGISTRY}/${IMAGE_NAME}:latest

clean:
	docker rmi ${REGISTRY}/${IMAGE_NAME}:${TAG} || true
	docker rmi ${REGISTRY}/${IMAGE_NAME}:latest || true

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
	./test.sh
