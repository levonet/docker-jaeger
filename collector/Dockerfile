ARG DOCKER_TAG=latest
FROM levonet/jaeger:${DOCKER_TAG} AS all-in-one

FROM debian:buster-slim

COPY --from=all-in-one /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=all-in-one /opt/bin/jaeger-collector /opt/bin/jaeger-collector

EXPOSE 14250
EXPOSE 14268
EXPOSE 14269

ENTRYPOINT ["/opt/bin/jaeger-collector"]
