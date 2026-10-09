UUID := $(shell sed -n 's/.*"uuid": *"\([^"]*\)".*/\1/p' assets/metadata.json)
ZIP := dist/$(UUID).shell-extension.zip

.PHONY: all deps build install uninstall enable disable clean

all: build

node_modules: package.json pnpm-lock.yaml
	pnpm install --frozen-lockfile
	@touch node_modules

deps: node_modules

build: node_modules
	pnpm build

install: build
	gnome-extensions install --force $(ZIP)
	@echo "Installed $(UUID)."
	@echo "Log out and back in (Wayland) or restart GNOME Shell (X11), then run: make enable"

uninstall:
	gnome-extensions uninstall $(UUID)

enable:
	gnome-extensions enable $(UUID)

disable:
	gnome-extensions disable $(UUID)

clean:
	rm -rf dist
