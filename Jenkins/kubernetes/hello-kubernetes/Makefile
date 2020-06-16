export NAMESPACE ?= default

export GIT_COMMIT ?= $(shell git rev-parse HEAD)

ifndef BUILD_NUMBER
  export TAG=$(GIT_COMMIT)
else
  export TAG=$(BUILD_NUMBER)-$(GIT_COMMIT)
endif

.PHONY: build template validate lint diff sync status destroy

build:
	$(MAKE) -C dockerfile

template: validate
	helmfile template

validate:
	helmfile template | kubeval --strict

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
