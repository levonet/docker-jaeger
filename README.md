# Jaeger Docker images

These Jaeger Docker images contain a [clickhouse plugin](https://github.com/jaegertracing/jaeger-clickhouse).

- [levonet/jaeger](https://hub.docker.com/r/levonet/jaeger) (all-in-one) — Designed for quick local testing. It launches the Jaeger UI, collector, query, and agent.
- [levonet/jaeger-agent](https://hub.docker.com/r/levonet/jaeger-agent) — Receives spans from Jaeger clients and forwards to collector. Designed to run as a sidecar or a host agent.
- [levonet/jaeger-collector](https://hub.docker.com/r/levonet/jaeger-collector) — Receives spans from agents or directly from clients and saves them in persistent storage.
- [levonet/jaeger-ingester](https://hub.docker.com/r/levonet/jaeger-ingester) — An alternative to collector; reads spans from Kafka topic and saves them to storage.
- [levonet/jaeger-query](https://hub.docker.com/r/levonet/jaeger-query) — Serves Jaeger UI and an API that retrieves traces from storage.

# Build and publish

The `make` command builds and publishes the latest state of the [jaegertracing/jaeger](https://github.com/jaegertracing/jaeger) repository with the [clickhouse plugin](https://github.com/jaegertracing/jaeger-clickhouse).
You can run specific build and publish steps with the appropriate `make build` and` make push` commands.

In order to build and publish a specific version, you need to define the version in environment variables.

```sh
JAEGER_VERSION=v1.28.0 JAEGER_CLICKHOUSE_VERSION=0.8.0 DOCKER_TAG=latest make build
DOCKER_TAG=latest make push
```

# Example

Run the Clickhouse claster (2 shards x 2 replicas) with the Jaeger cluster:

```sh
cd examples/cluster
docker-compose up
```

Open the link [0.0.0.0:8080](http://0.0.0.0:8080) in your browser and test it.

# Image Variants

The `levonet/jaeger*` images come in many flavors, each designed for a specific use case.

## `levonet/jaeger*:<version>`

This is the defacto image. If you are unsure about what your needs are, you probably want to use this one.
It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

Some of these tags may have names like buster in them. These are the suite code names for releases of [Debian](https://wiki.debian.org/DebianReleases) and indicate which release the image is based on. If your image needs to install any additional packages beyond what comes with the image, you'll likely want to specify one of these explicitly to minimize breakage when there are new releases of Debian.

## License

View [license information](https://github.com/jaegertracing/jaeger/blob/master/LICENSE) for the software contained in this image or [license information](https://github.com/levonet/docker-jaeger/blob/master/LICENSE) for the Jaeger Dockerfile.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
