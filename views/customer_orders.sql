CREATE MATERIALIZED VIEW IF NOT EXISTS customer_orders
AS
 SELECT customer.c_custkey AS co_custkey,
    count(orders.o_orderkey) AS co_ordercount
   FROM customer
     LEFT JOIN orders ON customer.c_custkey = orders.o_custkey AND orders.o_comment !~~ '%special%requests%'::text
  GROUP BY customer.c_custkey;
