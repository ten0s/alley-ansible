conf = {
    "_id" : "alley",
    "members" : [
        {"_id" : 0, "host" : "node1.dev1team.net:27017"},
        {"_id" : 1, "host" : "node2.dev1team.net:27017"},
        {"_id" : 2, "host" : "arbiter.dev1team.net:27017", "arbiterOnly" : true}
    ]
};

rs.initiate(conf);
