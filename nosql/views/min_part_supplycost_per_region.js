db.createView('min_part_supplycost_per_region', "partsupp",
    [{
    "$lookup" : {
      "localField" : "ps_suppkey",
      "from" : "supplier",
      "foreignField" : "s_suppkey",
      "as" : "s_suppkey"
    }
  }, {
    "$replaceRoot" : {
      "newRoot" : {
        "$mergeObjects" : [{
            "$arrayElemAt" : ["$s_suppkey", 0]
          }, "$$ROOT"]
      }
    }
  }, {
    "$lookup" : {
      "localField" : "s_nationkey",
      "from" : "nation",
      "foreignField" : "n_nationkey",
      "as" : "nation"
    }
  }, {
    "$replaceRoot" : {
      "newRoot" : {
        "$mergeObjects" : [{
            "$arrayElemAt" : ["$nation", 0]
          }, "$$ROOT"]
      }
    }
  }, {
    "$lookup" : {
      "localField" : "n_regionkey",
      "from" : "region",
      "foreignField" : "r_regionkey",
      "as" : "region"
    }
  }, {
    "$replaceRoot" : {
      "newRoot" : {
        "$mergeObjects" : [{
            "$arrayElemAt" : ["$region", 0]
          }, "$$ROOT"]
      }
    }
  }, {
    "$group" : {
      "_id" : {
        "mpsc_regionname" : "$r_name",
        "mpsc_partkey" : "$ps_partkey"
      },
      "mpsc_mincost" : {
        "$min" : "$ps_supplycost"
      }
    }
  }]
);