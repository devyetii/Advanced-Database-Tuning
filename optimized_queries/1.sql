select
	s_acctbal,
	s_name,
	n_name,
	p_partkey,
	p_mfgr,
	s_address,
	s_phone,
	s_comment
from
	partsupp
	join (select p_partkey, p_mfgr from part where p_size = 25 and p_type like '%COPPER') as f_part on p_partkey = ps_partkey
	join supplier on s_suppkey = ps_suppkey
	join min_part_supplycost_per_region on mpsc_partkey = ps_partkey
	join nation on s_nationkey = n_nationkey
where
	ps_supplycost = mpsc_mincost
	and mpsc_regionname = 'AFRICA'
order by
	s_acctbal desc,
	n_name,
	s_name,
	p_partkey;