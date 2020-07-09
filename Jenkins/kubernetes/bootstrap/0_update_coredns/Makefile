
# Update coredns configmap to make it work with local DNS

CONFIGMAP_FILE ?= coredns_cm.yaml

# Check for required binaries
EXECUTABLES = kubeval kubectl
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: validate apply diff

validate:
	kubeval --strict ${CONFIGMAP_FILE}

apply: validate
	kubectl apply -f ${CONFIGMAP_FILE} --wait=true

diff:
	kubectl diff -f ${CONFIGMAP_FILE}
