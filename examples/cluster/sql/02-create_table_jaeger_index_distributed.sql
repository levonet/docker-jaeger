CREATE TABLE IF NOT EXISTS tracing.jaeger_index_distributed AS tracing.jaeger_index
ENGINE = Distributed(busfor_cluster, tracing, jaeger_index, sipHash64(traceID))
