# Update coredns configmap to make it work with local DNS

CONFIGMAP_FILE = coredns_cm.yaml
PDB_FILE = pdb.yaml

# Check for required binaries
EXECUTABLES = kubeconform kubectl
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: validate apply diff

validate:
	mkdir -p /tmp/kubeconform
	kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.30.3 \
	${CONFIGMAP_FILE} ${PDB_FILE}

apply:
	@kubectl diff -f ${CONFIGMAP_FILE}; \
	if [ $$? -eq 0 ]; then \
	    echo "No changes in CoreDNS configmap."; \
	else \
	    kubectl apply -f ${CONFIGMAP_FILE} --wait=true; \
	    kubectl -n kube-system patch deploy/coredns -p "{\"spec\": {\"template\": {\"metadata\": { \"labels\": {  \"redeploy\": \"`date +'%s'`\"}}}}}"; \
	    kubectl -n kube-system rollout status deploy/coredns --timeout=120s --watch=true; \
	fi
	kubectl apply -f ${PDB_FILE}

diff:
	kubectl diff -f ${CONFIGMAP_FILE} -f ${PDB_FILE}

test:
	@echo "Running CoreDNS tests..."
	./coredns_tests.sh
