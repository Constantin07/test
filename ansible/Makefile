.PHONY: lint

SKIP_LIST=301

lint:
	@find ./*.yml -type f | xargs ansible-lint -x $(SKIP_LIST)
