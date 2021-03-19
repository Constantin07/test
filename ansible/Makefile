.PHONY: lint collections

lint:
	@find ./*.yml -type f | xargs ansible-lint

collections:
	ansible-galaxy collection install -r requirements.yml --force
