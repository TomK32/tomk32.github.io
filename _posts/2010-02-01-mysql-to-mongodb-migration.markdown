---
title: MySQL to MongoDB conversion
date: 2010-02-07
tags: MySQL MongoDB
layout: post
---
For photostre.am I wrote an migration script to migrate the MySQL database to MongoMapper.

Maybe it’s good use for someone, this is the actual script at [gist.github.com](https://gist.github.com/TomK32/290175) and no abstract something which you give up to extend after a while. The migration actually uses ActiveRecord::Migration, could well be about the last one that I’ll ever write.
