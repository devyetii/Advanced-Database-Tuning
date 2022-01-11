db.lineitem.aggregate(
[
    {
        $lookup: {
            from: 'part',
            localField: 'l_partkey',
            foreignField: 'p_partkey',
            pipeline: [
                {
                    $match: {
                        p_brand: 'Brand#23',
                        p_container: 'JUMBO BAG',
                        $expr: {
                            $lt: [
                                'l_quantity',
                                'lineitem_part.lp_quantityavg'
                            ]
                        }
                    }
                },
                {
                    $lookup: {
                        from: 'lineitem_part',
                        localField: 'p_partkey',
                        foreignField: 'lp_partkey',
                        as: 'lineitem_part'
                    }
                },
                {
                    $unwind: '$lineitem_part'
                }
            ],
            as: 'part'
        }
    },
    {
        $unwind: {
            path: '$part',
            preserveNullAndEmptyArrays: false
        }
    },
    {
        $group: {
            _id: 1,
            avg_yearly: {
                $sum: '$l_extendedprice'
            }
        }
    }, 
    {
        $project: {
            avg_yearly: {
                $multiply: [7,'$avg_yearly']
            }
       }
    }
])