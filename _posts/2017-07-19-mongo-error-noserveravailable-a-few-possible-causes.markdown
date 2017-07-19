---
layout: post
title: "Mongo::Error::NoServerAvailable - a few possible causes"
date: "2017-07-19 08:17:23 +0200"
tags: mongodb mongoid debugging server
---

Summer-time, perfect to make a major version upgrade -- from MongoDB 3.2 to 3.4 -- on the database servers.
Not without troubles. In my case: `Mongo::Error::NoServerAvailable No server is available matching preference`
A quick internet search will tell you that this is no uncommon error and the solutions
for it vary widely. Mind you, I'm not a server admin, my focus programming the backend of web apps.
In hope to help others a little, here's what went wrong with our db servers. None of the mistakes caused an issue
on MongoDB 3.2, only after the upgrade they system got a bit picky.

**DB hosts** couldn't connect to each other: For whatever reason I had the wrong IPs in the `/etc/hosts` file 
and in the replica set I used those short names rather than IPs. A bad choice.
Make sure you can successfully connect to each db server from each other db server.

**Mongoid didn't know the replica-set name** wasn't an issue on 3.2 but suddenly was now, an easy fix in the `mongoid.yml`.

As always when upgrade a replica set, start with the secondaries: `db.shutdownServer()`, upgrade the software and start it before moving
to the next and doing the primary last.
