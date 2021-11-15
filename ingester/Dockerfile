ARG DOCKER_TAG=latest
FROM levonet/jaeger:${DOCKER_TAG} AS all-in-one

FROM debian:bullseye-slim

COPY --from=all-in-one /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=all-in-one /opt/bin/jaeger-ingester /opt/bin/jaeger-ingester
COPY --from=all-in-one /opt/jaeger/plugin/jaeger-clickhouse /opt/jaeger/plugin/jaeger-clickhouse
COPY --from=all-in-one /opt/jaeger/config.yaml /opt/jaeger/config.yaml
COPY --from=all-in-one /opt/jaeger/sqlscripts /opt/jaeger/sqlscripts

ENV SPAN_STORAGE_TYPE grpc-plugin
WORKDIR /opt/jaeger

EXPOSE 14270
EXPOSE 14271

ENTRYPOINT ["/opt/bin/jaeger-ingester"]
CMD ["--grpc-storage-plugin.binary", "plugin/jaeger-clickhouse", "--grpc-storage-plugin.configuration-file", "config.yaml"]
