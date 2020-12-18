export NAMESPACE ?= kube-system

# Check for required binaries
EXECUTABLES = kubectl jq
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: protect test

protect:
	./protect.sh

# Upgrade tiller to helm version
test:
	./protect_tests.sh
