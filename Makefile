DOCKER_IMAGE=heroku

include Makefile.docker

PACKAGE_VERSION=0.1

include Makefile.package

.PHONY: check-version
check-version:
	docker run --rm $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):latest version|awk '{ print $$1 }'|awk -F '/' '{ print $$2 }'

test:; docker-compose -f docker-compose.test.yml build && heroku logs
