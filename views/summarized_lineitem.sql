CREATE MATERIALIZED VIEW public.summarized_lineitem
AS
select
	l_orderkey sl_orderkey,
	l_extendedprice * (1 - l_discount) as sl_finalprice,
	l_shipdate sl_shipdate
from lineitem