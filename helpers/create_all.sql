-- 0. CREATE DB
CREATE SCHEMA IF NOT EXISTS public;
GRANT ALL ON SCHEMA public TO PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;

-- 1. region, part
CREATE TABLE IF NOT EXISTS public.region
(
    r_regionkey integer NOT NULL,
    r_name character(25)  NOT NULL,
    r_comment character varying(152) ,
    CONSTRAINT region_pkey PRIMARY KEY (r_regionkey)
);

CREATE TABLE IF NOT EXISTS public.part
(
    p_partkey bigint NOT NULL,
    p_name character varying(55)  NOT NULL,
    p_mfgr character(25)  NOT NULL,
    p_brand character(10)  NOT NULL,
    p_type character varying(25)  NOT NULL,
    p_size integer NOT NULL,
    p_container character(10)  NOT NULL,
    p_retailprice double precision NOT NULL,
    p_comment character varying(23)  NOT NULL,
    CONSTRAINT part_kpey PRIMARY KEY (p_partkey)
);
-- 2. nation
CREATE TABLE IF NOT EXISTS public.nation
(
    n_nationkey integer NOT NULL,
    n_name character(25)  NOT NULL,
    n_regionkey integer NOT NULL,
    n_comment character varying(152) ,
    CONSTRAINT nation_pkey PRIMARY KEY (n_nationkey),
    CONSTRAINT nation_region_fkey FOREIGN KEY (n_regionkey)
        REFERENCES public.region (r_regionkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS idx_nation_regionkey
    ON public.nation USING btree
    (n_regionkey ASC NULLS LAST)
    ;
-- 3. customer, supplier
CREATE TABLE IF NOT EXISTS public.customer
(
    c_custkey bigint NOT NULL,
    c_name character varying(25)  NOT NULL,
    c_address character varying(40)  NOT NULL,
    c_nationkey integer NOT NULL,
    c_phone character(15)  NOT NULL,
    c_acctbal double precision NOT NULL,
    c_mktsegment character(10)  NOT NULL,
    c_comment character varying(117)  NOT NULL,
    CONSTRAINT customer_pkey PRIMARY KEY (c_custkey),
    CONSTRAINT customer_nation_fkey FOREIGN KEY (c_nationkey)
        REFERENCES public.nation (n_nationkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_customer_custkey_mktsegment
    ON public.customer USING btree
    (c_custkey ASC NULLS LAST, c_mktsegment  ASC NULLS LAST)
    ;

CREATE TABLE IF NOT EXISTS public.supplier
(
    s_suppkey bigint NOT NULL,
    s_name character(25)  NOT NULL,
    s_address character varying(40)  NOT NULL,
    s_nationkey integer NOT NULL,
    s_phone character(15)  NOT NULL,
    s_acctbal double precision NOT NULL,
    s_comment character varying(101)  NOT NULL,
    CONSTRAINT supplier_pkey PRIMARY KEY (s_suppkey),
    CONSTRAINT supplier_nation_fkey FOREIGN KEY (s_nationkey)
        REFERENCES public.nation (n_nationkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
CREATE INDEX IF NOT EXISTS idx_supplier_nation_key
    ON public.supplier USING btree
    (s_nationkey ASC NULLS LAST)
    ;

-- 4. partsupp, orders
CREATE TABLE IF NOT EXISTS public.partsupp
(
    ps_partkey bigint NOT NULL,
    ps_suppkey bigint NOT NULL,
    ps_availqty bigint NOT NULL,
    ps_supplycost double precision NOT NULL,
    ps_comment character varying(199)  NOT NULL,
    CONSTRAINT partsupp_pkey PRIMARY KEY (ps_partkey, ps_suppkey),
    CONSTRAINT partsupp_part_fkey FOREIGN KEY (ps_partkey)
        REFERENCES public.part (p_partkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT partsupp_supplier_fkey FOREIGN KEY (ps_suppkey)
        REFERENCES public.supplier (s_suppkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
CREATE INDEX IF NOT EXISTS idx_partsupp_partkey
    ON public.partsupp USING btree
    (ps_partkey ASC NULLS LAST)
    ;
CREATE INDEX IF NOT EXISTS idx_partsupp_suppkey
    ON public.partsupp USING btree
    (ps_suppkey ASC NULLS LAST)
    ;

CREATE TABLE IF NOT EXISTS public.orders
(
    o_orderkey bigint NOT NULL,
    o_custkey bigint NOT NULL,
    o_orderstatus character(1)  NOT NULL,
    o_totalprice double precision NOT NULL,
    o_orderdate date NOT NULL,
    o_orderpriority character(15)  NOT NULL,
    o_clerk character(15)  NOT NULL,
    o_shippriority integer NOT NULL,
    o_comment text  NOT NULL,
    CONSTRAINT orders_pkey PRIMARY KEY (o_orderkey),
    CONSTRAINT orders_customer_fkey FOREIGN KEY (o_custkey)
        REFERENCES public.customer (c_custkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
CREATE INDEX IF NOT EXISTS idx_orders_orderdate
    ON public.orders USING btree
    (o_orderdate ASC NULLS LAST)
    ;

-- 5. lineitem
CREATE TABLE IF NOT EXISTS public.lineitem
(
    l_orderkey bigint NOT NULL,
    l_partkey bigint NOT NULL,
    l_suppkey bigint NOT NULL,
    l_linenumber bigint NOT NULL,
    l_quantity double precision NOT NULL,
    l_extendedprice double precision NOT NULL,
    l_discount double precision NOT NULL,
    l_tax double precision NOT NULL,
    l_returnflag character(1)  NOT NULL,
    l_linestatus character(1)  NOT NULL,
    l_shipdate date NOT NULL,
    l_commitdate date NOT NULL,
    l_receiptdate date NOT NULL,
    l_shipinstruct character(25)  NOT NULL,
    l_shipmode character(10)  NOT NULL,
    l_comment character varying(44)  NOT NULL,
    CONSTRAINT lineitem_pkey PRIMARY KEY (l_orderkey, l_linenumber),
    CONSTRAINT lineitem_orders_fkey FOREIGN KEY (l_orderkey)
        REFERENCES public.orders (o_orderkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT lineitem_partsupp_fkey FOREIGN KEY (l_partkey, l_suppkey)
        REFERENCES public.partsupp (ps_partkey, ps_suppkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
CREATE INDEX IF NOT EXISTS idx_lineitem_partkey
    ON public.lineitem USING btree
    (l_partkey NULLS LAST)
    ;
CREATE INDEX IF NOT EXISTS idx_lineitem_orderkey
    ON public.lineitem USING btree
    (l_orderkey ASC NULLS LAST)
    INCLUDE(l_commitdate, l_receiptdate)
    ;

-- 6. Views
CREATE MATERIALIZED VIEW IF NOT EXISTS customer_orders
AS
 SELECT customer.c_custkey AS co_custkey,
    count(orders.o_orderkey) AS co_ordercount
   FROM customer
     LEFT JOIN orders ON customer.c_custkey = orders.o_custkey AND orders.o_comment !~~ '%special%requests%'::text
  GROUP BY customer.c_custkey;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.lineitem_part

AS
 SELECT lineitem.l_partkey AS lp_partkey,
    0.2 * avg(lineitem.l_quantity) AS lp_quantityavg
   FROM lineitem
  GROUP BY lineitem.l_partkey;

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
group by r_name, ps_partkey;

CREATE MATERIALIZED VIEW public.summarized_lineitem
AS
select
	l_orderkey sl_orderkey,
	l_extendedprice * (1 - l_discount) as sl_finalprice,
	l_shipdate sl_shipdate
from lineitem;

-- 7. Indexes on views
    CREATE INDEX idx_mpsc_regionname
        ON public.min_part_supplycost_per_region USING btree
        (mpsc_regionname ASC NULLS LAST)
    ;
    CREATE INDEX IF NOT EXISTS idx_lineitem_part_partkey
        ON public.lineitem_part USING btree
        (lp_partkey ASC NULLS LAST)
        ;
    ALTER TABLE IF EXISTS public.lineitem_part
        CLUSTER ON idx_lineitem_part_partkey;