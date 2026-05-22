# Advanced Database Profiling & Optimization

A hands-on database performance tuning project based on the **TPC-H benchmark schema**. This repository demonstrates how to systematically optimize complex analytical SQL queries using materialized views, strategic indexing, and query rewriting — with quantified before/after execution plans. It also includes a **NoSQL (MongoDB) comparison** for the same workload.

---

## What This Project Covers

- **TPC-H Benchmark** — Standard decision-support benchmark schema (Part, Supplier, Customer, Orders, Lineitem, Nation, Region, Partsupp)
- **Query Optimization** — Rewriting 5 TPC-H queries to eliminate cross products, replace correlated subqueries, and filter early
- **Materialized Views** — Pre-aggregating expensive computations to avoid scanning massive tables repeatedly
- **Index Tuning** — Clustered, non-clustered, and covering indexes for index-only scans
- **Execution Plan Analysis** — PostgreSQL `EXPLAIN ANALYZE` before/after comparisons
- **NoSQL Alternative** — MongoDB aggregation pipelines mirroring the relational workload

---

## Project Structure

```
.
├── original/                          # Original TPC-H DDL & unoptimized queries
│   ├── ddl.sql
│   ├── 1.sql ... 5.sql
├── optimized_queries/               # Rewritten, optimized SQL queries
│   ├── 1.sql ... 5.sql
├── views/                           # Materialized views for pre-aggregation
│   ├── min_part_supplycost_per_region.sql
│   ├── summarized_lineitem.sql
│   ├── lineitem_part.sql
│   └── customer_orders.sql
├── indexes/                         # Strategic index definitions
│   ├── idx_mpsc_regionname.sql
│   ├── idx_lineitem_orderkey.sql
│   ├── idx_orders_orderdate.sql
│   └── ...
├── helpers/                         # Database utility scripts
│   ├── create_all.sql
│   ├── drop_all.sql
│   ├── missing_index.sql
│   ├── sizes.sql
│   └── truncate.sql
├── nosql/                           # MongoDB aggregation equivalents
│   ├── 1.js ... 5.js
│   ├── indexes.js
│   └── views/
├── execution_plans.md               # Before/after EXPLAIN ANALYZE output
└── optimizations.md                 # Per-query optimization rationale
```

---

## Benchmark Queries

| Query | Original Runtime | Optimized Runtime | Key Technique |
|-------|-----------------|-------------------|---------------|
| **Q1** | ~23.6s | ~1.6s | Materialized view + clustered index + early filtering |
| **Q2** | ~26.4s | ~16.7s | Pre-aggregated `summarized_lineitem` view |
| **Q3** | ~49.1s | ~3.9s | Covering index + clustered index on `orders` |
| **Q4** | ~96.9s | ~1.0s | Pre-computed aggregation view + index-only scan |
| **Q5** | ~11.0s | ~0.3s | Lightweight `customer_orders` view |

> *Timings measured on a local PostgreSQL instance with the standard TPC-H scale factor. Actual numbers depend on hardware and dataset size.*

---

## Optimization Techniques

### 1. Materialized Views
Pre-compute expensive aggregations to eliminate repeated scans of large tables (especially `lineitem`):

- **`min_part_supplycost_per_region`** — Pre-aggregates minimum supply cost per part per region (replaces correlated subquery in Q1)
- **`summarized_lineitem`** — Pre-computes discounted prices and aggregates (replaces massive `lineitem` joins in Q2)
- **`lineitem_part`** — Pre-computes average quantity per part (eliminates `lineitem` aggregation in Q4)
- **`customer_orders`** — Lightweight summary of customer order counts (replaces nested subquery in Q5)

### 2. Strategic Indexing

| Index | Target | Purpose |
|-------|--------|---------|
| `idx_mpsc_regionname` | `min_part_supplycost_per_region` | Clustered index to eliminate sequential scan on region filter |
| `idx_lineitem_orderkey` | `lineitem(l_orderkey)` | Covering index (includes `l_commitdate`, `l_receiptdate`) for index-only scan |
| `idx_orders_orderdate` | `orders(o_orderdate)` | Clustered index for range filtering and sorting |
| `idx_lineitem_partkey` | `lineitem(l_partkey)` | Covering index (includes `l_quantity`, `l_extendedprice`) |
| `idx_customer_custkey_mktsegment` | `customer(c_custkey, c_mktsegment)` | Eliminates sequential scan in customer-market segment joins |

### 3. Query Rewriting
- **Filter before join** — Push down predicates (e.g., `p_size = 25`) to reduce join cardinality
- **Replace cross products with explicit joins** — Reduces planning time and enables better optimizer decisions
- **Substitute `count(*)` with `count(<column>)`** — Enables index-only scan in some cases
- **Eliminate correlated subqueries** — Replace with pre-computed materialized views

---

## How to Use

### Prerequisites
- PostgreSQL (tested on 14+)
- TPC-H data generated at your chosen scale factor (e.g., [dbgen](https://github.com/electrum/tpch-dbgen))

### Setup

```bash
# 1. Create the schema
psql -d your_database -f original/ddl.sql

# 2. Load TPC-H data using your preferred method
#    (e.g., COPY commands, dbgen output, or a pre-built dataset)

# 3. Create helper objects (optional)
psql -d your_database -f helpers/create_all.sql

# 4. Create views
psql -d your_database -f views/min_part_supplycost_per_region.sql
psql -d your_database -f views/summarized_lineitem.sql
psql -d your_database -f views/lineitem_part.sql
psql -d your_database -f views/customer_orders.sql

# 5. Create indexes
psql -d your_database -f indexes/idx_mpsc_regionname.sql
psql -d your_database -f indexes/idx_lineitem_orderkey.sql
psql -d your_database -f indexes/idx_orders_orderdate.sql
# ... apply remaining indexes as needed

# 6. Compare original vs optimized
psql -d your_database -c "EXPLAIN ANALYZE $(cat original/1.sql)"
psql -d your_database -c "EXPLAIN ANALYZE $(cat optimized_queries/1.sql)"
```

### Cleanup
```bash
psql -d your_database -f helpers/drop_all.sql
```

---

## NoSQL Comparison

The `nosql/` directory contains MongoDB aggregation pipelines (`1.js` ... `5.js`) that approximate the same TPC-H queries using:
- `$match` for filtering
- `$lookup` for joins
- `$group` for aggregation
- Pre-built views and indexes (`nosql/views/`, `nosql/indexes.js`)

This side of the project explores how document-oriented databases handle the same analytical workload and what optimizations (e.g., compound indexes, pre-aggregation) remain relevant across paradigms.

---

## Documentation

| File | Content |
|------|---------|
| `execution_plans.md` | Full `EXPLAIN ANALYZE` output for every query — before and after optimization |
| `optimizations.md` | Rationale per query: schema changes, memory reduction, query rewrites, and indexes applied |

---

## Key Takeaways

1. **Pre-aggregation is powerful** — Materialized views that summarize the massive `lineitem` table yield the biggest wins.
2. **Covering indexes matter** — Including frequently accessed columns in an index eliminates heap fetches (index-only scans).
3. **Filter early, join late** — Reducing row counts before expensive joins saves orders of magnitude in execution time.
4. **Correlated subqueries are expensive** — Replacing them with pre-computed views removes repeated execution.
5. **NoSQL requires similar thinking** — Even without JOINs, `$lookup` performance benefits from the same filtering and pre-aggregation strategies.

---

## Tech Stack

- **PostgreSQL** — Relational engine, query planner analysis, indexing
- **MongoDB** — NoSQL comparison via aggregation framework
- **TPC-H** — Standard benchmark schema and query set

---

## Author

[Ebrahim Gomaa](https://github.com/devyetii)

---

## License

This project is provided as an educational benchmark study. TPC-H schema and queries are derived from the TPC-H benchmark specification.
