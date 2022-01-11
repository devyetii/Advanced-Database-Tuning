select
	sum(l_extendedprice) / 7.0 as avg_yearly
from
        lineitem
        left join part on p_partkey = l_partkey
	left join lineitem_part on lp_partkey = p_partkey
where
        p_brand = 'Brand#23'
        and p_container = 'MED BOX' -- Change this to JUMBO PACK with 10k data
        and l_quantity < lp_quantityavg