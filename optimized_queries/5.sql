select
	c_count,
	count(c_custkey) as custdist
from
	customer_orders as c_orders (c_custkey, c_count)
group by
	c_count
order by
	custdist desc,
	c_count desc;
