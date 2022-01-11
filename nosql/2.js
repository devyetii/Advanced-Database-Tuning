db.orders.aggregate([{$addFields: {
   o_orderdate: {
    $dateFromString: {
     dateString: '$o_orderdate',
     format: '%Y-%m-%d'
    }
   }
  }}, {$lookup: {
   from: 'customer',
   localField: 'o_custkey',
   foreignField: 'c_custkey',
   as: 'customer'
  }}, {$unwind: {
   path: '$customer',
   preserveNullAndEmptyArrays: false
  }}, {$lookup: {
   from: 'summarized_lineitem',
   localField: 'o_orderkey',
   foreignField: 'sl_orderkey',
   pipeline: [
    {
     $addFields: {
      sl_shipdate: {
       $dateFromString: {
        dateString: '$sl_shipdate',
        format: '%Y-%m-%d'
       }
      }
     }
    }
   ],
   as: 'summarized_lineitem'
  }}, {$unwind: {
   path: '$summarized_lineitem',
   preserveNullAndEmptyArrays: false
  }}, {$match: {
   'customer.c_mktsegment': 'AUTOMOBILE',
   o_orderdate: {
    $lt: ISODate('1995-03-15T00:00:00.000Z')
   },
   'summarized_lineitem.sl_shipdate': {
    $gt: ISODate('1995-03-15T00:00:00.000Z')
   }
  }}, {$group: {
   _id: {
    sl_orderkey: '$summarized_lineitem.sl_orderkey',
    o_orderdate: '$o_orderdate',
    o_shippriority: '$o_shippriority'
   },
   revenue: {
    $sum: '$summarized_lineitem.sl_finalprice'
   }
  }}, {$sort: {
   revenue: -1,
   '_id.o_orderdate': 1
  }}])