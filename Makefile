JAEGER_VERSION?=master
JAEGER_CLICKHOUSE_VERSION?=main
IMAGE_VERSION?=latest
IMAGE_ALL_IN_ONE_TAG=levonet/jaeger:$(IMAGE_VERSION)

.PHONY: all
all: build push

.PHONY: build
build: build-jaeger build-jaeger-agent build-jaeger-collector build-jaeger-ingester build-jaeger-query

.PHONY: build-jaeger
build-jaeger:
	docker build \
		--progress plain \
		--build-arg JAEGER_VERSION=$(JAEGER_VERSION) \
		--build-arg JAEGER_CLICKHOUSE_VERSION=$(JAEGER_CLICKHOUSE_VERSION) \
		-t $(IMAGE_ALL_IN_ONE_TAG) \
		.

.PHONY: build-jaeger-agent
build-jaeger-agent:
	docker build \
		--progress plain \
		--build-arg DOCKER_TAG=$(IMAGE_ALL_IN_ONE_TAG) \
		-t levonet/jaeger-agent:$(IMAGE_VERSION) \
		agent

.PHONY: build-jaeger-collector
build-jaeger-collector:
	docker build \
		--progress plain \
		--build-arg DOCKER_TAG=$(IMAGE_ALL_IN_ONE_TAG) \
		-t levonet/jaeger-collector:$(IMAGE_VERSION) \
		collector

.PHONY: build-jaeger-ingester
build-jaeger-ingester:
	docker build \
		--progress plain \
		--build-arg DOCKER_TAG=$(IMAGE_ALL_IN_ONE_TAG) \
		-t levonet/jaeger-ingester:$(IMAGE_VERSION) \
		ingester

.PHONY: build-jaeger-query
build-jaeger-query:
	docker build \
		--progress plain \
		--build-arg DOCKER_TAG=$(IMAGE_ALL_IN_ONE_TAG) \
		-t levonet/jaeger-query:$(IMAGE_VERSION) \
		query

.PHONY: push
push: push-jaeger push-jaeger-agent push-jaeger-collector push-jaeger-ingester push-jaeger-query

.PHONY: push-jaeger
push-jaeger:
	docker push $(IMAGE_ALL_IN_ONE_TAG)

.PHONY: push-jaeger-agent
push-jaeger-agent:
	docker push levonet/jaeger-agent:$(IMAGE_VERSION)

.PHONY: push-jaeger-collector
push-jaeger-collector:
	docker push levonet/jaeger-collector:$(IMAGE_VERSION)

.PHONY: push-jaeger-ingester
push-jaeger-ingester:
	docker push levonet/jaeger-ingester:$(IMAGE_VERSION)

.PHONY: push-jaeger-query
push-jaeger-query:
	docker push levonet/jaeger-query:$(IMAGE_VERSION)
