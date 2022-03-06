SHELL := /bin/bash

.PHONY: all pip3-install clean
default: pip3-install lint

.venv:
	python3 -m venv .venv

pip3-install: .venv
	.venv/bin/pip3 install --no-cache-dir --upgrade pip setuptools
	.venv/bin/pip3 install --no-cache-dir -r requirements.txt

lint:
	.venv/bin/pylint get_kubeconfig.py

clean:
	@rm -rf .venv .terraform
