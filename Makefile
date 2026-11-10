VERSION := $(shell sed -n 's/^version: *//p' pubspec.yaml)

.PHONY: all help get format-check analyze test check dry-run publish tag release

all: release

help:
	@echo "Targets:"
	@echo "  all           Default target, same as release"
	@echo "  get           Install dependencies"
	@echo "  format-check  Fail if any file is not formatted"
	@echo "  analyze       Run static analysis"
	@echo "  test          Run tests"
	@echo "  check         Run format-check, analyze and test (same as CI)"
	@echo "  dry-run       Run checks and validate the package without publishing"
	@echo "  publish       Run checks and publish version $(VERSION) to pub.dev"
	@echo "  tag           Create and push the v$(VERSION) git tag"
	@echo "  release       publish + tag"

get:
	flutter pub get

format-check: get
	dart format -o none --set-exit-if-changed .

analyze: get
	flutter analyze

test: get
	flutter test

check: format-check analyze test

dry-run: check
	dart pub publish --dry-run

publish: dry-run
	dart pub publish

tag:
	@if git rev-parse "v$(VERSION)" >/dev/null 2>&1; then \
		echo "Tag v$(VERSION) already exists"; exit 1; \
	fi
	git tag "v$(VERSION)"
	git push origin "v$(VERSION)"

release: publish
	$(MAKE) tag
