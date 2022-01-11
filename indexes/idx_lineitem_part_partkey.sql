CREATE INDEX IF NOT EXISTS idx_lineitem_part_partkey
    ON public.lineitem_part USING btree
    (lp_partkey ASC NULLS LAST)
    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.lineitem_part
    CLUSTER ON idx_lineitem_part_partkey;