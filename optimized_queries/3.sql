select
	o_orderpriority,
	count(o_orderkey) as order_count
from
	orders
	inner join lineitem on l_orderkey = o_orderkey and l_commitdate < l_receiptdate
where
	o_orderdate >= date '1993-07-01'
	and o_orderdate < date '1993-07-01' + interval '3 months'
group by
	o_orderpriority
order by
	o_orderpriority;