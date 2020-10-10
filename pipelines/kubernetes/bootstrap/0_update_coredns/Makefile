
# Update coredns configmap to make it work with local DNS

CONFIGMAP_FILE ?= coredns_cm.yaml

# Check for required binaries
EXECUTABLES = kubeval kubectl
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: validate apply diff

validate:
	kubeval --strict "${CONFIGMAP_FILE}"

apply: validate
	@kubectl diff -f "${CONFIGMAP_FILE}"; \
	if [ $$? -eq 0 ]; then \
	    echo "No changes in CoreDNS configmap."; \
	else \
	    kubectl apply -f ${CONFIGMAP_FILE} --wait=true; \
	    kubectl -n kube-system patch deploy/coredns -p "{\"spec\": {\"template\": {\"metadata\": { \"labels\": {  \"redeploy\": \"`date +'%s'`\"}}}}}"; \
	    kubectl -n kube-system rollout status deploy/coredns --timeout=120s --watch=true; \
	fi

diff:
	kubectl diff -f ${CONFIGMAP_FILE}

test:
	@echo "Running CoreDNS tests..."
	./coredns_tests.sh
