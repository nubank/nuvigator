# TODO: This Makefile is a temporary fix while we don't migrate from CircleCI.
# Replace it with a CI/CD pipeline that publishes a new release every time a PR is merged.

VERSION := $(shell sed -n 's/^version: *//p' pubspec.yaml)

.PHONY: all help get format-check analyze test check dry-run publish tag github-release release

all: release

help:
	@echo "Targets:"
	@echo "  all             Default target, same as release"
	@echo "  get             Install dependencies"
	@echo "  format-check    Fail if any file is not formatted"
	@echo "  analyze         Run static analysis"
	@echo "  test            Run tests"
	@echo "  check           Run format-check, analyze and test (same as CI)"
	@echo "  dry-run         Run checks and validate the package without publishing"
	@echo "  publish         Run checks and publish version $(VERSION) to pub.dev"
	@echo "  tag             Create and push the v$(VERSION) git tag"
	@echo "  github-release  Create the v$(VERSION) GitHub Release from CHANGELOG.md"
	@echo "  release         publish + tag + github-release"

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

github-release:
	awk '$$0 == "## $(VERSION)" {f=1; next} /^## / {f=0} f' CHANGELOG.md | \
		gh release create "v$(VERSION)" --verify-tag --title "v$(VERSION)" --notes-file -

release: publish
	$(MAKE) tag
	$(MAKE) github-release
