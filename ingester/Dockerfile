ARG DOCKER_TAG=latest
FROM levonet/jaeger:${DOCKER_TAG} AS all-in-one

FROM debian:buster-slim

COPY --from=all-in-one /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=all-in-one /opt/bin/jaeger-ingester /opt/bin/jaeger-ingester

EXPOSE 14270
EXPOSE 14271

ENTRYPOINT ["/opt/bin/jaeger-ingester"]
