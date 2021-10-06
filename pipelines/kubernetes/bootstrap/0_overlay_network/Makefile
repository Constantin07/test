CONFIG_FILE ?= calico.yaml

# Check for required binaries
EXECUTABLES = kubeval kubectl
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: validate install diff delete

validate:
	kubeval --strict --ignore-missing-schemas \
	--kubernetes-version 1.20.11 --schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master \
	${CONFIG_FILE}

# Install Calico overlay network in K8s
install: validate
	@kubectl apply -f ${CONFIG_FILE} --wait=true
	@./wait.sh
	# Make sure CPU/RAM resources are guaranteed
	@kubectl -n kube-system set resources ds/calico-node --requests='cpu=250m,memory=128Mi' --limits='cpu=250m,memory=128Mi' || true

diff:
	kubectl diff -f ${CONFIG_FILE}

# Remove Calico from K8s
destroy:
	kubectl delete -f ${CONFIG_FILE} --wait=true
