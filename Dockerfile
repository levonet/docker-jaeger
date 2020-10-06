FROM levonet/golang:latest AS build

RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        binutils \
        ca-certificates \
        curl \
        git \
        make \
    && git clone https://github.com/jaegertracing/jaeger.git /go/src/jaeger \
    && cd /go/src/jaeger \
    && git remote add upstream https://github.com/bobrik/jaeger.git \
    && git fetch upstream \
    && git checkout upstream/ivan/clickhouse \
    #
    # && git config --global user.email "git@github.com" \
    # && git config --global user.name "Trivial" \
    # && git rebase origin/master \
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
        cmd/all-in-one/all-in-one-linux \
        cmd/agent/agent-linux \
        cmd/collector/collector-linux \
        cmd/ingester/ingester-linux \
        cmd/query/query-linux

FROM debian:buster-slim

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /go/src/jaeger/cmd/all-in-one/all-in-one-linux /opt/bin/jaeger
COPY --from=build /go/src/jaeger/cmd/agent/agent-linux /opt/bin/jaeger-agent
COPY --from=build /go/src/jaeger/cmd/collector/collector-linux /opt/bin/jaeger-collector
COPY --from=build /go/src/jaeger/cmd/ingester/ingester-linux /opt/bin/jaeger-ingester
COPY --from=build /go/src/jaeger/cmd/query/query-linux /opt/bin/jaeger-query
COPY --from=build /go/src/jaeger/jaeger-ui/packages/jaeger-ui/build /opt/jaeger-ui

EXPOSE 6831/udp
EXPOSE 6832/udp
EXPOSE 5778
EXPOSE 14268
EXPOSE 14250
EXPOSE 16686

VOLUME ["/tmp"]

CMD ["/opt/bin/jaeger", "--query.static-files", "/opt/jaeger-ui"]
