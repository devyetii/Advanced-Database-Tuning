## Here you can find logged all the performed optimizations per query

### Q1
#### Schema
- Created `min_part_supplycost_per_region` view to eliminate the subquery of minimum supply cost and eliminate the use of `region` column
#### Memory
- Eliminate usage of `region` column
#### Query
- Filter `part` table before joining
- Use Joins instead of cross product
- Use the created Materialized view 
#### Indexes
- `idx_mpsc_regionname` : clustered index on `regionname` col. in `min_part_supplycost_per_region` view to eliminate sequential search

### Q2
#### Schema
- Add the materialized view (summarized_lineitem)
#### Memory
- Stop using the massive lineitem table
#### Query
- Use joins insted of cross products to decrease planning time
- Use the view
#### Indexes
- `idx_cutomer_custkey_mktsegment` : Eliminate sequential search in join

### Q3
#### Schema
N/A
#### Memory
N/A
#### Query
- Substituted `count(*)` with `count(o_orderkey)`
#### Indexes
- `idx_lineitem_orderkey` : Non-clustered index to eliminate sequential search on the massive `lineitem` table and provide index-only scan
- `idx_orders_orderdate` : Clustered index on `orders.orderdate` to help in sorting and eliminate sequential search on `order` table


### Q4
#### Schema
- Created `lineitem_part` to help calculate aggregations on `lineitem` table
#### Memory
- Eliminated the use of the massive `lineitem`
#### Query
- Used `join` instead of cross product to reduce planning time
#### Indexes
- Created the `idx_lineitem_partkey` including l_quantity and `l_extendedprice` fields to reach index-only scan on lineitem
- Created `idx_lineitem_part_partkey` on `lineitem_part` view to eliminate seq. scan on it

### Q5
#### Schema
- Created a lightweight view `customer_orders` to eliminate usage of `orders` and `customer` tables directly in the query
#### Memory
- Eliminated the usage of `orders` and `customer` table
#### Query
- Used `count(<col_name>)` instead of `count(*)`
- Used the view instead of the nested subquery
#### Indexes
N/A