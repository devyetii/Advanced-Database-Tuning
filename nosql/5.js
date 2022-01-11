db.customer_orders.aggregate([
    {
        $group: {
            _id: '$co_ordercount',
            count: {
                $count: {}
            }
        }
    },
    {
        $project: {
            c_count: '$_id',
            custdist: '$count'
        }
    },
    {
        $sort: {
            custdist: -1,
            c_count: -1
        }
    }
]);