CREATE INDEX IF NOT EXISTS idx_lineitem_orderkey
    ON public.lineitem USING btree
    (l_orderkey ASC NULLS LAST)
    INCLUDE(l_commitdate, l_receiptdate)
    TABLESPACE pg_default;