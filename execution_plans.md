## Q1
### Before
```
 Sort  (cost=55546.49..55546.49 rows=1 width=198) (actual time=23597.200..23598.314 rows=443 loops=1)
   Sort Key: supplier.s_acctbal DESC, nation.n_name, supplier.s_name, part.p_partkey
   Sort Method: quicksort  Memory: 150kB
   ->  Hash Join  (cost=28568.48..55546.48 rows=1 width=198) (actual time=20878.786..23595.478 rows=443 loops=1)
         Hash Cond: ((part.p_partkey = partsupp.ps_partkey) AND ((SubPlan 1) = partsupp.ps_supplycost))
         ->  Gather  (cost=1000.00..6620.50 rows=795 width=34) (actual time=3.359..5.760 rows=798 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               ->  Parallel Seq Scan on part  (cost=0.00..5541.00 rows=331 width=34) (actual time=4.070..781.032 rows=266 loops=3)
                     Filter: (((p_type)::text ~~ '%COPPER'::text) AND (p_size = 25))
                     Rows Removed by Filter: 66401
         ->  Hash  (cost=21105.48..21105.48 rows=160000 width=180) (actual time=20786.695..20786.727 rows=156400 loops=1)
               Buckets: 32768  Batches: 16  Memory Usage: 2300kB
               ->  Nested Loop  (cost=6.64..21105.48 rows=160000 width=180) (actual time=2.668..17850.269 rows=156400 loops=1)
                     ->  Nested Loop  (cost=6.22..241.96 rows=2000 width=172) (actual time=2.575..188.483 rows=1955 loops=1)
                           ->  Hash Join  (cost=1.07..2.45 rows=5 width=30) (actual time=0.110..0.214 rows=5 loops=1)
                                 Hash Cond: (nation.n_regionkey = region.r_regionkey)
                                 ->  Seq Scan on nation  (cost=0.00..1.25 rows=25 width=34) (actual time=0.022..0.056 rows=25 loops=1)
                                 ->  Hash  (cost=1.06..1.06 rows=1 width=4) (actual time=0.037..0.043 rows=1 loops=1)
                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                       ->  Seq Scan on region  (cost=0.00..1.06 rows=1 width=4) (actual time=0.020..0.026 rows=1 loops=1)
                                             Filter: (r_name = 'AFRICA'::bpchar)
                                             Rows Removed by Filter: 4
                           ->  Bitmap Heap Scan on supplier  (cost=5.14..43.90 rows=400 width=150) (actual time=1.723..35.810 rows=391 loops=5)
                                 Recheck Cond: (s_nationkey = nation.n_nationkey)
                                 Heap Blocks: exact=952
                                 ->  Bitmap Index Scan on idx_supplier_nation_key  (cost=0.00..5.04 rows=400 width=0) (actual time=1.534..1.534 rows=391 loops=5)
                                       Index Cond: (s_nationkey = nation.n_nationkey)
                     ->  Index Scan using idx_partsupp_suppkey on partsupp  (cost=0.42..9.63 rows=80 width=24) (actual time=0.545..8.790 rows=80 loops=1955)
                           Index Cond: (ps_suppkey = supplier.s_suppkey)
         SubPlan 1
           ->  Aggregate  (cost=43.45..43.46 rows=1 width=8) (actual time=0.549..0.550 rows=1 loops=1241)
                 ->  Nested Loop  (cost=0.85..43.45 rows=1 width=8) (actual time=0.479..0.537 rows=1 loops=1241)
                       Join Filter: (nation_1.n_regionkey = region_1.r_regionkey)
                       Rows Removed by Join Filter: 3
                       ->  Seq Scan on region region_1  (cost=0.00..1.06 rows=1 width=4) (actual time=0.004..0.010 rows=1 loops=1241)
                             Filter: (r_name = 'AFRICA'::bpchar)
                             Rows Removed by Filter: 4
                       ->  Nested Loop  (cost=0.85..42.33 rows=4 width=12) (actual time=0.386..0.514 rows=4 loops=1241)
                             ->  Nested Loop  (cost=0.71..41.71 rows=4 width=12) (actual time=0.373..0.470 rows=4 loops=1241)
                                   ->  Index Scan using idx_partsupp_partkey on partsupp partsupp_1  (cost=0.42..8.50 rows=4 width=16) (actual time=0.337..0.352 rows=4 loops=1241)
                                         Index Cond: (ps_partkey = part.p_partkey)
                                   ->  Index Scan using supplier_pkey on supplier supplier_1  (cost=0.29..8.30 rows=1 width=12) (actual time=0.023..0.023 rows=1 loops=4964)
                                         Index Cond: (s_suppkey = partsupp_1.ps_suppkey)
                             ->  Index Scan using nation_pkey on nation nation_1  (cost=0.14..0.16 rows=1 width=8) (actual time=0.005..0.005 rows=1 loops=4964)
                                   Index Cond: (n_nationkey = supplier_1.s_nationkey)
```
### After
```
 Sort  (cost=14353.69..14353.69 rows=1 width=198) (actual time=1615.741..1628.509 rows=443 loops=1)
   Sort Key: supplier.s_acctbal DESC, nation.n_name, supplier.s_name, part.p_partkey
   Sort Method: quicksort  Memory: 150kB
   ->  Nested Loop  (cost=7868.59..14353.68 rows=1 width=198) (actual time=917.085..1622.041 rows=443 loops=1)
         ->  Nested Loop  (cost=7868.46..14353.52 rows=1 width=176) (actual time=916.688..1614.844 rows=443 loops=1)
               ->  Gather  (cost=7868.17..14353.22 rows=1 width=42) (actual time=915.526..1556.557 rows=443 loops=1)
                     Workers Planned: 2
                     Workers Launched: 2
                     ->  Nested Loop  (cost=6868.17..13353.12 rows=1 width=42) (actual time=835.052..1509.977 rows=148 loops=3)
                           Join Filter: (part.p_partkey = partsupp.ps_partkey)
                           ->  Parallel Hash Join  (cost=6867.75..13120.63 rows=194 width=50) (actual time=834.050..1437.642 rows=148 loops=3)
                                 Hash Cond: (min_part_supplycost_per_region.mpsc_partkey = part.p_partkey)
                                 ->  Parallel Bitmap Heap Scan on min_part_supplycost_per_region  (cost=1322.61..7447.60 rows=48720 width=16) (actual time=48.922..598.338 rows=38722 loops=3)
                                       Recheck Cond: (mpsc_regionname = 'AFRICA'::bpchar)
                                       Heap Blocks: exact=1766
                                       ->  Bitmap Index Scan on idx_mpsc_regionname  (cost=0.00..1293.38 rows=116927 width=0) (actual time=45.069..45.070 rows=116165 loops=1)
                                             Index Cond: (mpsc_regionname = 'AFRICA'::bpchar)
                                 ->  Parallel Hash  (cost=5541.00..5541.00 rows=331 width=34) (actual time=781.631..781.635 rows=266 loops=3)
                                       Buckets: 1024  Batches: 1  Memory Usage: 104kB
                                       ->  Parallel Seq Scan on part  (cost=0.00..5541.00 rows=331 width=34) (actual time=7.200..779.518 rows=266 loops=3)
                                             Filter: (((p_type)::text ~~ '%COPPER'::text) AND (p_size = 25))
                                             Rows Removed by Filter: 66401
                           ->  Index Scan using idx_partsupp_partkey on partsupp  (cost=0.42..1.19 rows=1 width=24) (actual time=0.461..0.478 rows=1 loops=443)
                                 Index Cond: (ps_partkey = min_part_supplycost_per_region.mpsc_partkey)
                                 Filter: (min_part_supplycost_per_region.mpsc_mincost = ps_supplycost)
                                 Rows Removed by Filter: 3
               ->  Index Scan using supplier_pkey on supplier  (cost=0.29..0.30 rows=1 width=150) (actual time=0.123..0.123 rows=1 loops=443)
                     Index Cond: (s_suppkey = partsupp.ps_suppkey)
         ->  Index Scan using nation_pkey on nation  (cost=0.14..0.16 rows=1 width=30) (actual time=0.009..0.009 rows=1 loops=443)
               Index Cond: (n_nationkey = supplier.s_nationkey)
```

## Q2
### Before
```
 Sort  (cost=224979.22..225740.96 rows=304696 width=24) (actual time=26379.460..26395.471 rows=11529 loops=1)
   Sort Key: (sum((lineitem.l_extendedprice * ('1'::double precision - lineitem.l_discount)))) DESC, orders.o_orderdate
   Sort Method: quicksort  Memory: 1285kB
   ->  Finalize GroupAggregate  (cost=152589.58..190974.97 rows=304696 width=24) (actual time=26182.133..26322.713 rows=11529 loops=1)
         Group Key: lineitem.l_orderkey, orders.o_orderdate, orders.o_shippriority
         ->  Gather Merge  (cost=152589.58..185388.87 rows=253914 width=24) (actual time=26182.101..26270.799 rows=11529 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               ->  Partial GroupAggregate  (cost=151589.55..155080.87 rows=126957 width=24) (actual time=25973.461..26023.149 rows=3843 loops=3)
                     Group Key: lineitem.l_orderkey, orders.o_orderdate, orders.o_shippriority
                     ->  Sort  (cost=151589.55..151906.95 rows=126957 width=32) (actual time=25973.342..25988.677 rows=10126 loops=3)
                           Sort Key: lineitem.l_orderkey, orders.o_orderdate, orders.o_shippriority
                           Sort Method: quicksort  Memory: 1179kB
                           Worker 0:  Sort Method: quicksort  Memory: 1145kB
                           Worker 1:  Sort Method: quicksort  Memory: 1203kB
                           ->  Nested Loop  (cost=4646.48..137789.42 rows=126957 width=32) (actual time=791.716..25926.170 rows=10126 loops=3)
                                 ->  Parallel Hash Join  (cost=4646.05..41540.03 rows=59028 width=16) (actual time=784.806..6870.368 rows=48224 loops=3)
                                       Hash Cond: (orders.o_custkey = customer.c_custkey)
                                       ->  Parallel Seq Scan on orders  (cost=0.00..36096.50 rows=303795 width=24) (actual time=1.707..5426.471 rows=242435 loops=3)
                                             Filter: (o_orderdate < '1995-03-15'::date)
                                             Rows Removed by Filter: 257565
                                       ->  Parallel Hash  (cost=4494.25..4494.25 rows=12144 width=8) (actual time=782.272..782.277 rows=9917 loops=3)
                                             Buckets: 32768  Batches: 1  Memory Usage: 1472kB
                                             ->  Parallel Seq Scan on customer  (cost=0.00..4494.25 rows=12144 width=8) (actual time=113.644..756.143 rows=9917 loops=3)
                                                   Filter: (c_mktsegment = 'AUTOMOBILE'::bpchar)
                                                   Rows Removed by Filter: 40083
                                 ->  Index Scan using idx_lineitem_orderkey on lineitem  (cost=0.43..1.54 rows=9 width=24) (actual time=0.385..0.388 rows=0 loops=144672)
                                       Index Cond: (l_orderkey = orders.o_orderkey)
                                       Filter: (l_shipdate > '1995-03-15'::date)
                                       Rows Removed by Filter: 4
```
### After
```
 Sort  (cost=206253.25..207040.46 rows=314881 width=24) (actual time=16693.807..16718.550 rows=11529 loops=1)
   Sort Key: (sum(summarized_lineitem.sl_finalprice)) DESC, orders.o_orderdate
   Sort Method: quicksort  Memory: 1285kB
   ->  Finalize GroupAggregate  (cost=132024.34..171036.62 rows=314881 width=24) (actual time=16544.543..16679.332 rows=11529 loops=1)
         Group Key: summarized_lineitem.sl_orderkey, orders.o_orderdate, orders.o_shippriority
         ->  Gather Merge  (cost=132024.34..165263.81 rows=262400 width=24) (actual time=16544.498..16634.929 rows=20418 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               ->  Partial GroupAggregate  (cost=131024.31..133976.31 rows=131200 width=24) (actual time=16361.621..16399.269 rows=6806 loops=3)
                     Group Key: summarized_lineitem.sl_orderkey, orders.o_orderdate, orders.o_shippriority
                     ->  Sort  (cost=131024.31..131352.31 rows=131200 width=24) (actual time=16361.573..16372.371 rows=10126 loops=3)
                           Sort Key: summarized_lineitem.sl_orderkey, orders.o_orderdate, orders.o_shippriority
                           Sort Method: quicksort  Memory: 1144kB
                           Worker 0:  Sort Method: quicksort  Memory: 1207kB
                           Worker 1:  Sort Method: quicksort  Memory: 1176kB
                           ->  Parallel Hash Join  (cost=42020.67..117179.89 rows=131200 width=24) (actual time=9571.346..16330.781 rows=10126 loops=3)
                                 Hash Cond: (summarized_lineitem.sl_orderkey = orders.o_orderkey)
                                 ->  Parallel Seq Scan on summarized_lineitem  (cost=0.00..69481.33 rows=1368326 width=16) (actual time=3250.423..8169.573 rows=1080592 loops=3)
                                       Filter: (sl_shipdate > '1995-03-15'::date)
                                       Rows Removed by Filter: 919813
                                 ->  Parallel Hash  (cost=41271.57..41271.57 rows=59928 width=16) (actual time=6319.179..6319.210 rows=48224 loops=3)
                                       Buckets: 262144  Batches: 1  Memory Usage: 8864kB
                                       ->  Parallel Hash Join  (cost=4379.48..41271.57 rows=59928 width=16) (actual time=126.072..6157.126 rows=48224 loops=3)
                                             Hash Cond: (orders.o_custkey = customer.c_custkey)
                                             ->  Parallel Seq Scan on orders  (cost=0.00..36096.50 rows=303073 width=24) (actual time=59.244..5478.444 rows=242435 loops=3)
                                                   Filter: (o_orderdate < '1995-03-15'::date)
                                                   Rows Removed by Filter: 257565
                                             ->  Parallel Hash  (cost=4225.00..4225.00 rows=12358 width=8) (actual time=66.554..66.572 rows=9917 loops=3)
                                                   Buckets: 32768  Batches: 1  Memory Usage: 1440kB
                                                   ->  Parallel Index Only Scan using idx_customer_custkey_mktsegment on customer  (cost=0.42..4225.00 rows=12358 width=8) (actual time=80.853..150.143 rows=29752 loops=1)
```
## Q3
### Before
```
 Finalize GroupAggregate  (cost=219433.38..219577.48 rows=5 width=24) (actual time=49086.977..52160.378 rows=5 loops=1)
   Group Key: orders.o_orderpriority
   ->  Gather Merge  (cost=219433.38..219577.38 rows=10 width=24) (actual time=49079.234..52160.276 rows=15 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial GroupAggregate  (cost=218433.35..218576.20 rows=5 width=24) (actual time=48895.749..48927.748 rows=5 loops=3)
               Group Key: orders.o_orderpriority
               ->  Sort  (cost=218433.35..218480.95 rows=19040 width=16) (actual time=48888.020..48906.383 rows=17508 loops=3)
                     Sort Key: orders.o_orderpriority
                     Sort Method: quicksort  Memory: 1605kB
                     Worker 0:  Sort Method: quicksort  Memory: 1573kB
                     Worker 1:  Sort Method: quicksort  Memory: 1589kB
                     ->  Parallel Hash Semi Join  (cost=175582.10..217079.92 rows=19040 width=16) (actual time=45065.436..48850.329 rows=17508 loops=3)
                           Hash Cond: (orders.o_orderkey = lineitem.l_orderkey)
                           ->  Parallel Seq Scan on orders  (cost=0.00..37659.00 rows=24075 width=24) (actual time=3.069..5516.317 rows=19073 loops=3)
                                 Filter: ((o_orderdate >= '1993-07-01'::date) AND (o_orderdate < '1993-10-01 00:00:00'::timestamp without time zone))
                                 Rows Removed by Filter: 480927
                           ->  Parallel Hash  (cost=161907.33..161907.33 rows=833502 width=8) (actual time=36967.377..36967.382 rows=1264432 loops=3)
                                 Buckets: 131072 (originally 131072)  Batches: 64 (originally 32)  Memory Usage: 3424kB
                                 ->  Parallel Seq Scan on lineitem  (cost=0.00..161907.33 rows=833502 width=8) (actual time=61.818..25389.375 rows=1264432 loops=3)
                                       Filter: (l_commitdate < l_receiptdate)
                                       Rows Removed by Filter: 735973
```
### After
```
Finalize GroupAggregate  (cost=82358.82..82360.08 rows=5 width=24) (actual time=3913.657..3934.433 rows=5 loops=1)
   Group Key: orders.o_orderpriority
   ->  Gather Merge  (cost=82358.82..82359.98 rows=10 width=24) (actual time=3913.633..3934.401 rows=15 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Sort  (cost=81358.79..81358.80 rows=5 width=24) (actual time=3801.028..3801.045 rows=5 loops=3)
               Sort Key: orders.o_orderpriority
               Sort Method: quicksort  Memory: 25kB
               Worker 0:  Sort Method: quicksort  Memory: 25kB
               Worker 1:  Sort Method: quicksort  Memory: 25kB
               ->  Partial HashAggregate  (cost=81358.68..81358.73 rows=5 width=24) (actual time=3800.881..3800.898 rows=5 loops=3)
                     Group Key: orders.o_orderpriority
                     Batches: 1  Memory Usage: 24kB
                     Worker 0:  Batches: 1  Memory Usage: 24kB
                     Worker 1:  Batches: 1  Memory Usage: 24kB
                     ->  Nested Loop  (cost=792.44..81199.41 rows=31854 width=24) (actual time=13.065..3711.965 rows=48290 loops=3)
                           ->  Parallel Bitmap Heap Scan on orders  (cost=792.01..29500.29 rows=23885 width=24) (actual time=11.888..220.328 rows=19073 loops=3)
                                 Recheck Cond: ((o_orderdate >= '1993-07-01'::date) AND (o_orderdate < '1993-10-01 00:00:00'::timestamp without time zone))
                                 Heap Blocks: exact=371
                                 ->  Bitmap Index Scan on idx_orders_orderdate  (cost=0.00..777.68 rows=57325 width=0) (actual time=33.741..33.742 rows=57218 loops=1)
                                       Index Cond: ((o_orderdate >= '1993-07-01'::date) AND (o_orderdate < '1993-10-01 00:00:00'::timestamp without time zone))
                           ->  Index Only Scan using idx_lineitem_orderkey_ext on lineitem  (cost=0.43..2.14 rows=2 width=8) (actual time=0.172..0.176 rows=3 loops=57218)
                                 Index Cond: (l_orderkey = orders.o_orderkey)
                                 Filter: (l_commitdate < l_receiptdate)
                                 Rows Removed by Filter: 1
                                 Heap Fetches: 0

```
## Q4
### Before
```
 Aggregate  (cost=214261.63..214261.64 rows=1 width=8) (actual time=96865.883..96866.086 rows=1 loops=1)
   ->  Hash Join  (cost=6563.05..214256.73 rows=1960 width=8) (actual time=963.703..96864.396 rows=587 loops=1)
         Hash Cond: (lineitem.l_partkey = part.p_partkey)
         Join Filter: (lineitem.l_quantity < (SubPlan 1))
         Rows Removed by Join Filter: 5501
         ->  Seq Scan on lineitem  (cost=0.00..190663.15 rows=6001215 width=24) (actual time=1.056..86593.052 rows=6001215 loops=1)
         ->  Hash  (cost=6560.60..6560.60 rows=196 width=8) (actual time=957.969..958.155 rows=204 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 16kB
               ->  Gather  (cost=1000.00..6560.60 rows=196 width=8) (actual time=93.875..957.316 rows=204 loops=1)
                     Workers Planned: 2
                     Workers Launched: 2
                     ->  Parallel Seq Scan on part  (cost=0.00..5541.00 rows=82 width=8) (actual time=61.092..807.126 rows=68 loops=3)
                           Filter: ((p_brand = 'Brand#23'::bpchar) AND (p_container = 'MED BOX'::bpchar))

         SubPlan 1
           ->  Aggregate  (cost=127.71..127.72 rows=1 width=8) (actual time=0.231..0.232 rows=1 loops=6088)
                 ->  Bitmap Heap Scan on lineitem lineitem_1  (cost=4.67..127.63 rows=31 width=8) (actual time=0.058..0.171 rows=31 loops=6088)
                       Recheck Cond: (l_partkey = part.p_partkey)
                       Heap Blocks: exact=186965
                       ->  Bitmap Index Scan on idx_lineitem_partkey  (cost=0.00..4.67 rows=31 width=0) (actual time=0.032..0.032 rows=31 loops=6088)
                             Index Cond: (l_partkey = part.p_partkey)
```
### After
```
 Finalize Aggregate  (cost=7305.93..7305.94 rows=1 width=8) (actual time=992.479..1004.097 rows=1 loops=1)
   ->  Gather  (cost=7305.71..7305.92 rows=2 width=8) (actual time=992.222..1004.071 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=6305.71..6305.72 rows=1 width=8) (actual time=838.618..838.631 rows=1 loops=3)
               ->  Nested Loop  (cost=0.85..6303.67 rows=817 width=8) (actual time=35.730..838.230 rows=196 loops=3)
                     Join Filter: (part.p_partkey = lineitem.l_partkey)
                     ->  Nested Loop  (cost=0.42..6158.39 rows=82 width=24) (actual time=34.201..830.163 rows=68 loops=3)
                           ->  Parallel Seq Scan on part  (cost=0.00..5541.00 rows=82 width=8) (actual time=34.031..825.182 rows=68 loops=3)
                                 Filter: ((p_brand = 'Brand#23'::bpchar) AND (p_container = 'MED BOX'::bpchar))
                                 Rows Removed by Filter: 66599
                           ->  Index Scan using idx_lineitem_part_partkey on lineitem_part  (cost=0.42..7.52 rows=1 width=16) (actual time=0.057..0.059 rows=1 loops=204)
                                 Index Cond: (lp_partkey = part.p_partkey)
                     ->  Index Only Scan using idx_lineitem_partkey on lineitem  (cost=0.43..1.65 rows=10 width=24) (actual time=0.082..0.106 rows=3 loops=204)
                           Index Cond: (l_partkey = lineitem_part.lp_partkey)
                           Filter: (l_quantity < lineitem_part.lp_quantityavg)
                           Rows Removed by Filter: 27
                           Heap Fetches: 0
```
## Q5
### Before
```
Sort  (cost=161268.24..161268.74 rows=200 width=16) (actual time=11000.450..12001.094 rows=42 loops=1)
   Sort Key: (count(*)) DESC, (count(orders.o_orderkey)) DESC
   Sort Method: quicksort  Memory: 26kB
   ->  HashAggregate  (cost=161258.60..161260.60 rows=200 width=16) (actual time=11000.315..12000.975 rows=42 loops=1)
         Group Key: count(orders.o_orderkey)
         Batches: 1  Memory Usage: 40kB
         ->  Finalize GroupAggregate  (cost=121006.16..159008.60 rows=150000 width=16) (actual time=10383.798..11863.583 rows=150000 loops=1)
               Group Key: customer.c_custkey
               ->  Gather Merge  (cost=121006.16..156008.60 rows=300000 width=16) (actual time=10383.765..11612.330 rows=150000 loops=1)
                     Workers Planned: 2
                     Workers Launched: 2
                     ->  Sort  (cost=120006.13..120381.13 rows=150000 width=16) (actual time=10233.165..10275.596 rows=50000 loops=3)
                           Sort Key: customer.c_custkey
                           Sort Method: quicksort  Memory: 3738kB
                           Worker 0:  Sort Method: quicksort  Memory: 3723kB
                           Worker 1:  Sort Method: quicksort  Memory: 3668kB
                           ->  Partial HashAggregate  (cost=96941.77..104544.68 rows=150000 width=16) (actual time=9560.464..10169.609 rows=50000 loops=3)
                                 Group Key: customer.c_custkey
                                 Planned Partitions: 4  Batches: 5  Memory Usage: 4145kB  Disk Usage: 7808kB
                                 Worker 0:  Batches: 5  Memory Usage: 4145kB  Disk Usage: 7816kB
                                 Worker 1:  Batches: 5  Memory Usage: 4145kB  Disk Usage: 7704kB
                                 ->  Parallel Hash Left Join  (cost=47026.64..56906.68 rows=624938 width=16) (actual time=6209.793..8126.949 rows=511308 loops=3)
                                       Hash Cond: (customer.c_custkey = orders.o_custkey)
                                       ->  Parallel Index Only Scan using customer_pkey on customer  (cost=0.42..3031.42 rows=62500 width=8) (actual time=2.278..48.752 rows=50000 loops=3)
                                             Heap Fetches: 0
                                       ->  Parallel Hash  (cost=36162.50..36162.50 rows=624938 width=16) (actual time=5158.950..5158.953 rows=494639 loops=3)
                                             Buckets: 131072  Batches: 32  Memory Usage: 3296kB
                                             ->  Parallel Seq Scan on orders  (cost=0.00..36162.50 rows=624938 width=16) (actual time=35.656..3120.761 rows=494639 loops=3)
                                                   Filter: (o_comment !~~ '%special%requests%'::text)
                                                   Rows Removed by Filter: 5361
```
### After
```
 Sort  (cost=3062.46..3062.56 rows=40 width=16) (actual time=268.445..268.471 rows=42 loops=1)
   Sort Key: (count(c_custkey)) DESC, c_count DESC
   Sort Method: quicksort  Memory: 26kB
   ->  HashAggregate  (cost=3061.00..3061.40 rows=40 width=16) (actual time=268.356..268.392 rows=42 loops=1)
         Group Key: c_count
         Batches: 1  Memory Usage: 24kB
         ->  Seq Scan on customer_orders c_orders  (cost=0.00..2311.00 rows=150000 width=16) (actual time=0.015..111.470 rows=150000 loops=1)
```