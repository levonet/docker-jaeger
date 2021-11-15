FROM golang:1.17-bullseye AS build

ARG JAEGER_VERSION master
ARG JAEGER_CLICKHOUSE_VERSION main

RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        binutils \
        ca-certificates \
        curl \
        git \
        make

RUN set -eux \
    && git clone --depth=1 --single-branch -b ${JAEGER_VERSION} \
        https://github.com/jaegertracing/jaeger.git \
        /go/src/github.com/jaegertracing/jaeger \
    && cd /go/src/github.com/jaegertracing/jaeger \
    #
    && git submodule update --init --recursive \
    && curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n \
    && bash n lts \
    && curl -o- -L https://yarnpkg.com/install.sh | bash \
    && export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH" \
    && export GOOS="$(go env GOOS)" \
    && go install github.com/mjibson/esc@v0.2.0 \
    && make build-ui \
    && make build-platform-binaries \
    && strip \
        cmd/all-in-one/all-in-one-linux-amd64 \
        cmd/agent/agent-linux-amd64 \
        cmd/collector/collector-linux-amd64 \
        cmd/ingester/ingester-linux-amd64 \
        cmd/query/query-linux-amd64 \
        cmd/tracegen/tracegen-linux-amd64 \
        cmd/anonymizer/anonymizer-linux-amd64

RUN set -eux \
    && git clone --depth=1 --single-branch -b ${JAEGER_CLICKHOUSE_VERSION} \
        https://github.com/jaegertracing/jaeger-clickhouse.git \
        /go/src/github.com/jaegertracing/jaeger-clickhouse \
    && cd /go/src/github.com/jaegertracing/jaeger-clickhouse \
    && make build \
    && strip \
        jaeger-clickhouse-linux-amd64

FROM debian:bullseye-slim

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/agent/agent-linux-amd64 /opt/bin/jaeger-agent
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/all-in-one/all-in-one-linux-amd64 /opt/bin/jaeger
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/anonymizer/anonymizer-linux-amd64 /opt/bin/anonymizer
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/collector/collector-linux-amd64 /opt/bin/jaeger-collector
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/ingester/ingester-linux-amd64 /opt/bin/jaeger-ingester
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/query/query-linux-amd64 /opt/bin/jaeger-query
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/tracegen/tracegen-linux-amd64 /opt/bin/tracegen
COPY --from=build /go/src/github.com/jaegertracing/jaeger/jaeger-ui/packages/jaeger-ui/build /opt/jaeger/ui
COPY --from=build /go/src/github.com/jaegertracing/jaeger-clickhouse/jaeger-ui.json /opt/jaeger/jaeger-ui.json
COPY --from=build /go/src/github.com/jaegertracing/jaeger-clickhouse/jaeger-clickhouse-linux-amd64 /opt/jaeger/plugin/jaeger-clickhouse
COPY --from=build /go/src/github.com/jaegertracing/jaeger-clickhouse/config.yaml /opt/jaeger/config.yaml
COPY --from=build /go/src/github.com/jaegertracing/jaeger-clickhouse/sqlscripts /opt/jaeger/sqlscripts

ENV SPAN_STORAGE_TYPE grpc-plugin
WORKDIR /opt/jaeger

EXPOSE 6831/udp
EXPOSE 6832/udp
EXPOSE 5778
EXPOSE 14268
EXPOSE 14250
EXPOSE 16686

VOLUME ["/tmp"]

CMD ["/opt/bin/jaeger", "--query.static-files", "ui", "--query.ui-config", "jaeger-ui.json", "--grpc-storage-plugin.binary", "plugin/jaeger-clickhouse", "--grpc-storage-plugin.configuration-file", "config.yaml"]
