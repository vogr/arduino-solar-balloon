SHELL:= bash
TARGET = ballon-solaire

.PHONY: build
build:
	nix-build -A $(TARGET)

.PHONY: build
debug:
	nix-build . --run-env -A $(TARGET)

.PHONY: deploy
deploy:
	nix-shell . -A deployEnv --run "deployScript.sh"
