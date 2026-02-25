.PHONY: lint collections

deps:
	pip3 install -r requirements.txt

lint:
	@find ./*.yml -type f | xargs ansible-lint

collections:
	ansible-galaxy collection install -r requirements.yml --force
