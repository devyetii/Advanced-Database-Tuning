CREATE MATERIALIZED VIEW min_part_supplycost_per_region
AS
select
	r_name as mpsc_regionname, ps_partkey as mpsc_partkey,
	min(ps_supplycost) as mpsc_mincost
from
	partsupp
	inner join supplier on s_suppkey = ps_suppkey
	inner join nation on s_nationkey = n_nationkey
	inner join region on n_regionkey = r_regionkey
group by r_name, ps_partkey