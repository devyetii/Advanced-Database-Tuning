db.createView("summarized_lineitem","lineitem",[
    {
        $project: {
            'sl_orderkey': '$l_orderkey',
            'sl_finalprice': {$multiply:["$l_extendedprice",{$subtract:[1,"$l_discount"]}]},
            "sl_shipdate":"$l_shipdate"
        }
    }
])