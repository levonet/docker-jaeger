CREATE TABLE IF NOT EXISTS tracing.jaeger_archive_spans (
    timestamp DateTime CODEC(Delta, ZSTD(1)),
    traceID String CODEC(ZSTD(1)),
    model String CODEC(ZSTD(3))
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/tracing.jaeger_archive_spans', '{replica}')
PARTITION BY toYYYYMM(timestamp)
ORDER BY traceID
TTL toDate(timestamp) + INTERVAL 6 WEEK DELETE
SETTINGS index_granularity=1024
