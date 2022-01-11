db.createView('customer_orders', 'customer', [
    {
        $lookup: {
            from: 'orders',
            localField: 'c_custkey',
            foreignField: 'o_custkey',
            pipeline: [
                {
                    $match: { 'o_comment': { $not: { $regex: /.*special.*requests.*/ } } }
                }
            ],
            as: 'orders'
        }
    },
    {
        $group: {
            '_id': 'c_custkey',
            'co_ordercount': { $count: "$orders.o_orderkey"},
        }
    },
])

