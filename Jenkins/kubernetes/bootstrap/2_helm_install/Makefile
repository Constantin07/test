
NAMESPACE ?= kube-system

# Install tiller in K8s
.PHONY: install upgrade delete

install:
	kubectl apply -f rbac-config.yaml
	helm init --client-only
	helm repo update
	helm init --upgrade --service-account tiller --tiller-namespace ${NAMESPACE} --history-max 200 --wait --output yaml \
	| sed 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' \
	| sed 's@  replicas: 1@  replicas: 1\n  selector: {"matchLabels": {"app": "helm", "name": "tiller"}}@' \
	| kubectl apply -f -
#	helm init --upgrade --service-account tiller --tiller-namespace ${NAMESPACE} --history-max 200 --wait

# Upgrade tiller to helm version
upgrade:
	helm init --upgrade --tiller-namespace ${NAMESPACE}

# Remove tiller from K8s
delete:
	helm reset --tiller-namespace ${NAMESPACE} || true
	kubectl delete -f rbac-config.yaml || true
