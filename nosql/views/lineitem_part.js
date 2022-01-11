db.createView('lineitem_part', 'lineitem', [
    {
        $group: {
            '_id': 'l_partkey',
            'lp_quantityavg': { $multiply: [0.2, {$avg: "l_quantity"}] }
        }
    }
]);