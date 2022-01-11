CREATE INDEX IF NOT EXISTS idx_orders_orderdate
    ON public.orders USING btree
    (o_orderdate ASC NULLS LAST)
    TABLESPACE pg_default;
