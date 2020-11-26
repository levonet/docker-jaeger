CREATE TABLE IF NOT EXISTS tracing.jaeger_archive_spans_distributed AS tracing.jaeger_archive_spans
ENGINE = Distributed(busfor_cluster, tracing, jaeger_archive_spans, sipHash64(traceID))
