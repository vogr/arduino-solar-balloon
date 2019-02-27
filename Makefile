SHELL:= bash
TARGET = ballon-solaire

.PHONY: build
build:
	nix-build . -A $(TARGET)

.PHONY: build
debug:
	nix-build . --run-env -A $(TARGET)

.PHONY: deploy
deploy:
	nix-shell . --pure -A deployShell --run "deployScript.sh"

.build: serial
serial:
	nix-shell "<nixpkgs>" --pure -p picocom --run "picocom /dev/ttyACM0"
