export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = git helmfile kubeval
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: build template validate lint diff sync status destroy

GIT_COMMIT_SHORT ?= $(shell git rev-parse --short HEAD)

ifdef BUILD_NUMBER
export TAG=${BUILD_NUMBER}-${GIT_COMMIT_SHORT}
else
export TAG=${GIT_COMMIT_SHORT}
endif

build:
	$(MAKE) -C dockerfile

template:
	helmfile template

validate:
	helmfile template | kubeval --strict \
	--kubernetes-version 1.21.7 --schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master

lint:
	helmfile lint

diff:
	helmfile diff

sync: validate
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
