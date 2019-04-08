
.PHONY: all
all: .venv pip-install

.venv:
	python3 -m venv .venv

.PHONY: pip-install
pip-install:
	.venv/bin/pip install --upgrade pip
	.venv/bin/pip install -r requirements.txt

.PHONY: clean
clean:
	@rm -rf .venv
