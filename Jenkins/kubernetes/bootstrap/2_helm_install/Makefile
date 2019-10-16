
NAMESPACE ?= kube-system
SERVICE_ACCOUNT ?= tiller
CONFIG_FILE ?= rbac-config.yaml

# Install tiller in K8s
.PHONY: validate install upgrade delete

validate:
	kubeval --strict ${CONFIG_FILE}

install: validate
	kubectl apply -f ${CONFIG_FILE}
	helm init --client-only
	helm repo update
	helm init --upgrade --service-account ${SERVICE_ACCOUNT} --tiller-namespace ${NAMESPACE} --history-max 200 --wait

# Upgrade tiller to helm version
upgrade:
	helm init --upgrade --force-upgrade --tiller-namespace ${NAMESPACE}

# Remove tiller from K8s
delete:
	helm reset --tiller-namespace ${NAMESPACE} || true
	kubectl delete -f ${CONFIG_FILE} || true
