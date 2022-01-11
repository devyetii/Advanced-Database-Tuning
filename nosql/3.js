db.orders.aggregate([{$addFields: {
    o_orderdate: {
     $dateFromString: {
      dateString: '$o_orderdate',
      format: '%Y-%m-%d'
     }
    }
   }}, {$match: {
    o_orderdate: {
     $gte: ISODate('1993-07-01T00:00:00.000Z'),
     $lt: ISODate('1993-10-01T00:00:00.000Z')
    }
   }}, {$lookup: {
    from: 'lineitem',
    localField: 'o_orderkey',
    foreignField: 'l_orderkey',
    pipeline: [
     {
      $match: {
       $expr: {
        $lt: [
         'l_commitdate',
         'l_receiptdate'
        ]
       }
      }
     },
     {
      $addFields: {
       l_commitdate: {
        $dateFromString: {
         dateString: '$l_commitdate',
         format: '%Y-%m-%d'
        }
       },
       l_receiptdate: {
        $dateFromString: {
         dateString: '$l_receiptdate',
         format: '%Y-%m-%d'
        }
       }
      }
     }
    ],
    as: 'lineitem'
   }}, {$unwind: {
    path: '$lineitem',
    preserveNullAndEmptyArrays: false
   }}, {$group: {
    _id: '$o_orderpriority',
    o_orderkey: {
     $count: {}
    }
   }}, {$sort: {
    o_orderpriority: 1
   }}])