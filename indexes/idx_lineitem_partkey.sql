CREATE INDEX IF NOT EXISTS idx_lineitem_partkey
    ON public.lineitem USING btree
    (l_partkey ASC NULLS LAST)
    INCLUDE(l_quantity, l_extendedprice)
    TABLESPACE pg_default;