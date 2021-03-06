CREATE MATERIALIZED VIEW IF NOT EXISTS tracing.jaeger_operations
ENGINE SummingMergeTree
PARTITION BY toYYYYMM(date) ORDER BY (date, service, operation)
SETTINGS index_granularity=32
POPULATE
AS SELECT
    toDate(timestamp) AS date,
    service,
    operation,
    count() as count
FROM tracing.jaeger_index_distributed 
GROUP BY date, service, operation
