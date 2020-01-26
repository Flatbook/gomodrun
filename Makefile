.DEFAULT_GOAL := build
VERSION := 0.0.4

build:
	cd cmd/gomodrun && go build -o ../../gomodrun -ldflags="-X main.version=$(VERSION)"

install:
	cd cmd/gomodrun && go install -ldflags="-X main.version=$(VERSION)"

lint:
	gomodrun golangci-lint run

lint-fix:
	gomodrun golangci-lint run --fix

release:
	git tag -a "v$(VERSION)" -m "v$(VERSION)"
	git push --tags
	gomodrun goreleaser --rm-dist

release-snapshot:
	gomodrun goreleaser --snapshot --skip-publish --rm-dist

test:
	gomodrun ginkgo -v -r .
	make build && rm gomodrun

test-coverage:
	gomodrun ginkgo -v -r -race -cover -coverprofile=coverage.txt -covermode=atomic -outputdir=. .
	make build && rm gomodrun
	gomodrun goveralls -coverprofile=coverage.txt -service=travis-ci -repotoken $$COVERALLS_TOKEN
