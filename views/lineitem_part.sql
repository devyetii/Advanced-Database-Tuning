CREATE MATERIALIZED VIEW IF NOT EXISTS public.lineitem_part
AS
 SELECT lineitem.l_partkey AS lp_partkey,
    0.2 * avg(lineitem.l_quantity) AS lp_quantityavg
   FROM lineitem
  GROUP BY lineitem.l_partkey