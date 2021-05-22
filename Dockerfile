FROM levonet/golang:latest AS build

ARG BASE_REF=refs/heads/master
RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        binutils \
        ca-certificates \
        curl \
        git \
        make \
    && git clone https://github.com/jaegertracing/jaeger.git /go/src/github.com/jaegertracing/jaeger \
    && cd /go/src/github.com/jaegertracing/jaeger \
    #
    && git remote add upstream https://github.com/levonet/jaeger.git \
    && git fetch upstream \
    && git checkout upstream/ivan/clickhouse \
    && git config --global user.email "git@github.com" \
    && git config --global user.name "Trivial" \
    && git rebase $BASE_REF \
    #
    && git submodule update --init --recursive \
    && export GOOS="$(go env GOOS)" \
    && go install github.com/mjibson/esc \
    && curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n \
    && bash n lts \
    && curl -o- -L https://yarnpkg.com/install.sh | bash \
    && export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH" \
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

FROM debian:buster-slim

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/all-in-one/all-in-one-linux-amd64 /opt/bin/jaeger
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/agent/agent-linux-amd64 /opt/bin/jaeger-agent
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/collector/collector-linux-amd64 /opt/bin/jaeger-collector
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/ingester/ingester-linux-amd64 /opt/bin/jaeger-ingester
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/query/query-linux-amd64 /opt/bin/jaeger-query
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/tracegen/tracegen-linux-amd64 /opt/bin/tracegen
COPY --from=build /go/src/github.com/jaegertracing/jaeger/cmd/anonymizer/anonymizer-linux-amd64 /opt/bin/anonymizer
COPY --from=build /go/src/github.com/jaegertracing/jaeger/jaeger-ui/packages/jaeger-ui/build /opt/jaeger-ui

EXPOSE 6831/udp
EXPOSE 6832/udp
EXPOSE 5778
EXPOSE 14268
EXPOSE 14250
EXPOSE 16686

VOLUME ["/tmp"]

CMD ["/opt/bin/jaeger", "--query.static-files", "/opt/jaeger-ui"]
