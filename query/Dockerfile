ARG DOCKER_TAG=latest
FROM levonet/jaeger:${DOCKER_TAG} AS all-in-one

FROM debian:buster-slim

COPY --from=all-in-one /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=all-in-one /opt/bin/jaeger-query /opt/bin/jaeger-query
COPY --from=all-in-one /opt/jaeger-ui /opt/jaeger-ui

EXPOSE 16686
EXPOSE 16687

ENTRYPOINT ["/opt/bin/jaeger-query"]
CMD ["--query.static-files", "/opt/jaeger-ui"]
