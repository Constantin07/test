
export NAMESPACE ?= default
export HEADERS_FILE ?= headers-configmap.yaml
export CONFIGMAP_NAME ?= nginx-ingress-headers

.PHONY: init validate template lint diff sync status destroy

init:
	helm init --client-only
	helm repo update

validate:
	gomplate -f ${HEADERS_FILE} | kubeval --strict
	helmfile template | kubeval --strict

template:
	helmfile template

lint:
	helmfile lint

diff:
	gomplate -f ${HEADERS_FILE} | kubectl diff -n ${NAMESPACE} -f -
	helmfile diff

sync: validate
	gomplate -f ${HEADERS_FILE}
	gomplate -f ${HEADERS_FILE} | kubectl apply -n ${NAMESPACE} -f -
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
	kubectl delete -f ${HEADERS_FILE} -n ${NAMESPACE}
