JAEGER_VERSION?=master
JAEGER_CLICKHOUSE_VERSION?=main
DOCKER_TAG?=latest

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
		-t levonet/jaeger:${DOCKER_TAG} \
		.

.PHONY: build-jaeger-agent
build-jaeger-agent:
	docker build \
		--progress plain \
		--build-arg DOCKER_TAG=$(DOCKER_TAG) \
		-t levonet/jaeger-agent:${DOCKER_TAG} \
		agent

.PHONY: build-jaeger-collector
build-jaeger-collector:
	docker build \
		--progress plain \
		--build-arg DOCKER_TAG=$(DOCKER_TAG) \
		-t levonet/jaeger-collector:${DOCKER_TAG} \
		collector

.PHONY: build-jaeger-ingester
build-jaeger-ingester:
	docker build \
		--progress plain \
		--build-arg DOCKER_TAG=$(DOCKER_TAG) \
		-t levonet/jaeger-ingester:${DOCKER_TAG} \
		ingester

.PHONY: build-jaeger-query
build-jaeger-query:
	docker build \
		--progress plain \
		--build-arg DOCKER_TAG=$(DOCKER_TAG) \
		-t levonet/jaeger-query:${DOCKER_TAG} \
		query

.PHONY: push
push: push-jaeger push-jaeger-agent push-jaeger-collector push-jaeger-ingester push-jaeger-query

.PHONY: push-jaeger
push-jaeger:
	docker push levonet/jaeger:${DOCKER_TAG}

.PHONY: push-jaeger-agent
push-jaeger-agent:
	docker push levonet/jaeger-agent:${DOCKER_TAG}

.PHONY: push-jaeger-collector
push-jaeger-collector:
	docker push levonet/jaeger-collector:${DOCKER_TAG}

.PHONY: push-jaeger-ingester
push-jaeger-ingester:
	docker push levonet/jaeger-ingester:${DOCKER_TAG}

.PHONY: push-jaeger-query
push-jaeger-query:
	docker push levonet/jaeger-query:${DOCKER_TAG}
