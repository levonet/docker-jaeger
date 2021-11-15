ARG DOCKER_TAG=latest
FROM levonet/jaeger:${DOCKER_TAG} AS all-in-one

FROM debian:bullseye-slim

COPY --from=all-in-one /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=all-in-one /opt/bin/jaeger-query /opt/bin/jaeger-query
COPY --from=all-in-one /opt/jaeger/ui /opt/jaeger/ui
COPY --from=all-in-one /opt/jaeger/jaeger-ui.json /opt/jaeger/jaeger-ui.json
COPY --from=all-in-one /opt/jaeger/plugin/jaeger-clickhouse /opt/jaeger/plugin/jaeger-clickhouse
COPY --from=all-in-one /opt/jaeger/config.yaml /opt/jaeger/config.yaml
COPY --from=all-in-one /opt/jaeger/sqlscripts /opt/jaeger/sqlscripts

ENV SPAN_STORAGE_TYPE grpc-plugin
WORKDIR /opt/jaeger

EXPOSE 16686
EXPOSE 16687

ENTRYPOINT ["/opt/bin/jaeger-query"]
CMD ["--query.static-files", "ui", "--query.ui-config", "jaeger-ui.json", "--grpc-storage-plugin.binary", "plugin/jaeger-clickhouse", "--grpc-storage-plugin.configuration-file", "config.yaml"]
