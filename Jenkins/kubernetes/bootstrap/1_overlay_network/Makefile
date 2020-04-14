CONFIG_FILE ?= calico.yaml

.PHONY: validate install diff delete

validate:
	kubeval --ignore-missing-schemas ${CONFIG_FILE}

# Install Calico overlay network in K8s
install: validate
	kubectl apply -f ${CONFIG_FILE} --wait=true
	./wait.sh
	# Make sure CPU/RAM resources are guaranteed
	kubectl set resources ds/calico-node -n kube-system --limits='cpu=250m,memory=128Mi' --requests='cpu=250m,memory=128Mi' || true

diff:
	kubectl diff -f ${CONFIG_FILE}

# Remove Calico from K8s
destroy:
	kubectl delete -f ${CONFIG_FILE} --wait=true
