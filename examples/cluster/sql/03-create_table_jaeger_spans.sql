CREATE TABLE IF NOT EXISTS tracing.jaeger_spans (
    timestamp DateTime CODEC(Delta, ZSTD(1)),
    traceID String CODEC(ZSTD(1)),
    model String CODEC(ZSTD(3))
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/tracing.jaeger_spans', '{replica}')
PARTITION BY toDate(timestamp)
ORDER BY traceID
TTL toDate(timestamp) + INTERVAL 2 DAY DELETE
SETTINGS index_granularity = 1024
