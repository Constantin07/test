
export NAMESPACE ?= default
export HEADERS_FILE ?= headers-configmap.yaml
export CONFIGMAP_NAME ?= nginx-ingress-headers

.PHONY: init template lint diff sync status destroy

init:
	helm init --client-only

template:
	helmfile template

lint:
	helmfile lint

diff:
	gomplate -f ${HEADERS_FILE} | kubectl diff -n ${NAMESPACE} -f -
	helmfile diff

sync:
	gomplate -f ${HEADERS_FILE} | tee /dev/tty | kubectl apply -n ${NAMESPACE} -f -
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
	kubectl delete -f ${HEADERS_FILE} -n ${NAMESPACE}
