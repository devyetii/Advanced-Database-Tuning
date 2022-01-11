db.lineitem.createIndex({ l_orderkey: 1, l_partkey: 1 })

db.customer.createIndex({ c_custkey: 1 }, { unique: 1 })

db.customer.createIndex({ c_custkey: 1, c_mktsegment: 'text' })

db.orders.createIndex({ o_orderdate: 1, o_orderkey: 1 })