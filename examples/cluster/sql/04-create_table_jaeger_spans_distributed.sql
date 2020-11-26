CREATE TABLE IF NOT EXISTS tracing.jaeger_spans_distributed AS tracing.jaeger_spans
ENGINE = Distributed(busfor_cluster, tracing, jaeger_spans, sipHash64(traceID))
