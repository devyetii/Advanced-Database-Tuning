select
	sl_orderkey,
	sum(sl_finalprice) as revenue,
	o_orderdate,
	o_shippriority
from
	orders
	join customer on c_custkey = o_custkey
	join summarized_lineitem on sl_orderkey = o_orderkey
where
	c_mktsegment = 'AUTOMOBILE'
	and o_orderdate < '1995-03-15'
	and sl_shipdate > '1995-03-15'
group by
	sl_orderkey,
	o_orderdate,
	o_shippriority
order by
	revenue desc,
	o_orderdate;