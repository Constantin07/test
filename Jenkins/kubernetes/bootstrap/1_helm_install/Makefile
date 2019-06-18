
NAMESPACE ?= kube-system

# Install tiller in K8s
.PHONY: install upgrade delete
install:
	kubectl apply -f rbac-config.yaml
	helm init --client-only
	helm repo update
	helm init --service-account tiller --tiller-namespace ${NAMESPACE} --history-max 200 --wait

# Upgrade tiller to helm version
upgrade:
	helm init --upgrade --tiller-namespace ${NAMESPACE}

# Remove tiller from K8s
delete:
	helm reset --tiller-namespace ${NAMESPACE} || true
	kubectl delete -f rbac-config.yaml || true
