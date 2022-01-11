CREATE UNIQUE INDEX IF NOT EXISTS idx_customer_custkey_mktsegment
    ON public.customer USING btree
    (c_custkey ASC NULLS LAST, c_mktsegment COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;