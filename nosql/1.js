db.partsupp.aggregate([
    { $match: {'ps_supplycost': 'mpsc_mincost', 'mpsc_regionname': 'AFRICA'} },
    { $sort: { s_acctbal: -1, n_name: 1, s_name: 1, p_partkey } },
    { $lookup: {
        from: 'part',
        localField: 'ps_partkey',
        foreignField: 'p_partkey',
        pipeline: [
            { 
                $match: {
                    p_size: 25,
                    p_type: /COPPER$/
                }
            },
            { $project: { p_partkey: 1, p_mfgr: 1 } }
        ]}
    },
    { }
]);