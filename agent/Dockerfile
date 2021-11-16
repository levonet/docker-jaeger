ARG DOCKER_TAG levonet/jaeger:latest
FROM ${DOCKER_TAG} AS all-in-one

FROM debian:stretch-slim

COPY --from=all-in-one /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=all-in-one /opt/bin/jaeger-agent /opt/bin/jaeger-agent

# EXPOSE 5775/udp
EXPOSE 5778
EXPOSE 6831/udp
EXPOSE 6832/udp
EXPOSE 14271

ENTRYPOINT ["/opt/bin/jaeger-agent"]
