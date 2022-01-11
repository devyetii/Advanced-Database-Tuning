CREATE INDEX idx_mpsc_regionname
    ON public.min_part_supplycost_per_region USING btree
    (mpsc_regionname ASC NULLS LAST)
;