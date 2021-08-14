export NAMESPACE ?= default

export HEADERS_FILE = headers-configmap.yaml
export HEADERS_CONFIGMAP_NAME = nginx-ingress-headers

# Check for required binaries
EXECUTABLES = helm helmfile gomplate kubectl kubeval
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init validate template lint diff sync status destroy

init:
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update

validate:
	gomplate -f ${HEADERS_FILE} | kubeval --strict
	helmfile template | kubeval --strict \
	--kubernetes-version 1.20.10 --schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master

template:
	helmfile template

lint:
	helmfile lint

diff:
	gomplate -f ${HEADERS_FILE} | kubectl diff -f -
	helmfile diff

sync: validate
	gomplate -f ${HEADERS_FILE} | tee /dev/tty | kubectl apply -f -
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
	gomplate -f ${HEADERS_FILE} | kubectl delete --ignore-not-found=true -f -
