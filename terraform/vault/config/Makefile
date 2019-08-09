SHELL := /bin/bash

.PHONY: all
all: .venv pip3-install

.venv:
	python3 -m venv .venv

.PHONY: pip3-install
pip3-install:
	.venv/bin/pip3 install --upgrade pip
	.venv/bin/pip3 install -r requirements.txt

.PHONY: clean
clean:
	@rm -rf .venv
